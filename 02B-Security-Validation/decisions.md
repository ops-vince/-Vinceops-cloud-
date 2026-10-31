# VinceOps Month 2B — Engineering Decisions

This document records the principal infrastructure decisions made while evolving the VinceOps workload from the Month 2 single-instance deployment into a more resilient, privately hosted and observable AWS architecture.

The purpose is to preserve the **reasoning behind the architecture**, including trade-offs, rather than only documenting the final AWS resources.

---

## 1. Move the Application Tier into Private Subnets

### Decision

The VinceOps web servers were placed inside private subnets without public IPv4 addresses.

### Why

The application servers did not need to receive direct internet traffic.

Public traffic could instead terminate at the Application Load Balancer, which would forward requests to the private web tier.

This reduced the externally reachable attack surface and created a clearer separation between ingress infrastructure and application compute.

### Trade-off

Private instances require additional infrastructure for:

* administrative access,
* outbound internet connectivity,
* software installation,
* monitoring integrations,
* and other external dependencies.

This increased architectural complexity but provided stronger workload isolation.

### Outcome

Internet users could reach the application through the ALB without making the EC2 application fleet directly reachable from the internet.

---

## 2. Use a Bastion Host for Administrative Access

### Decision

Administrative SSH access to the private web tier was routed through a public bastion host.

### Why

The private EC2 instances had no public addresses, but controlled administrative access was still required during implementation and troubleshooting.

The bastion provided a single controlled entry point instead of exposing SSH individually across the application fleet.

### Security Benefit

The traffic path became:

```text id="yvwgxc"
Administrator
     │
     ▼
Bastion Host
     │
     ▼
Private EC2
```

The web-tier security group could therefore permit SSH from the bastion security group instead of from the public internet.

### Trade-off

A bastion host introduces another resource that must be secured, maintained and monitored.

In a more mature production environment, AWS Systems Manager Session Manager could be evaluated as an alternative that removes the need for an internet-facing SSH host.

---

## 3. Distribute the Workload Across Two Availability Zones

### Decision

The Month 2B environment used public and private subnets across `us-east-1a` and `us-east-1b`.

### Why

The Month 2 architecture still relied on a single compute location.

Distributing application capacity across multiple Availability Zones reduced dependency on one AZ and allowed the load balancer and Auto Scaling Group to operate across separate failure domains.

### Trade-off

Multi-AZ architecture introduces additional routing, subnet and storage considerations.

It can also increase cost compared with a single-AZ environment.

### Outcome

The VinceOps application fleet could operate across two Availability Zones rather than relying on one infrastructure location.

---

## 4. Use NAT for Private Workload Egress

### Decision

Private application instances accessed required internet services through a NAT Gateway.

### Why

The web servers needed outbound connectivity for tasks such as package installation and external monitoring integration, but they did not need direct inbound internet exposure.

The NAT path preserved private addressing while supporting outbound communication.

### Trade-off

NAT Gateway introduces additional hourly and data-processing cost.

For a cost-sensitive environment, VPC endpoints and dependency reduction could be considered where appropriate.

### Outcome

Private EC2 instances retained outbound connectivity without becoming publicly addressable.

---

## 5. Use Amazon EFS for Shared Web Content

### Decision

Amazon EFS was used as the shared application content layer for the web fleet.

### Why

Auto Scaling requires instances to be replaceable.

If application content existed only on one EC2 root volume, a newly launched instance could start without the same web content.

EFS provided a shared filesystem that multiple instances could mount.

### Implementation

The design included:

* a regional EFS filesystem,
* mount targets across the application Availability Zones,
* an EFS access point,
* TLS-enabled mounting,
* persistent `/etc/fstab` configuration,
* and shared content mounted at `/var/www/html`.

### Trade-off

EFS adds another service dependency and introduces network-filesystem latency compared with local disk.

For the VinceOps Month 2B workload, consistency across replaceable application nodes was more important than local-storage performance.

---

## 6. Use Launch Templates Instead of Manually Configured Servers

### Decision

The web-tier configuration was defined through an EC2 Launch Template and bootstrap automation.

### Why

Manually configuring each EC2 instance would make Auto Scaling unreliable and produce configuration drift.

The Launch Template provided a repeatable definition for new application nodes.

### Operational Benefit

New instances could automatically perform tasks such as:

* dependency installation,
* EFS mounting,
* Nginx configuration,
* health validation,
* and monitoring-agent configuration.

### Trade-off

Bootstrap automation becomes operational code.

Errors in User Data can affect every newly launched instance, making testing and versioning essential.

### Outcome

Launch Template versions were used during troubleshooting so configuration changes could be introduced while retaining previous known-good versions.

---

## 7. Use Auto Scaling for Replaceable Compute

### Decision

The application fleet was placed behind an Auto Scaling Group.

The working capacity model was:

```text id="jsst4y"
Minimum: 2
Desired: 2
Maximum: 4
```

### Why

A single EC2 instance represented both a capacity limit and a single point of failure.

Auto Scaling provided a mechanism to maintain the required number of application instances and launch replacements when necessary.

### Scaling Model

A CPU target-tracking policy was used to demonstrate demand-responsive capacity management.

### Trade-off

Auto Scaling only works reliably when instances can initialise without manual intervention.

This increased the importance of:

* deterministic bootstrap automation,
* externalised application state,
* IAM permissions,
* health checks,
* and dependency availability.

### Outcome

The web servers were treated as replaceable infrastructure rather than permanent machines.

---

## 8. Use an Application Load Balancer as the Public Entry Point

### Decision

An internet-facing Application Load Balancer became the entry point for the Month 2B application.

### Why

Directly exposing individual application servers would undermine the private-compute architecture and make scaling difficult.

The ALB provided:

* a stable ingress point,
* target-group integration,
* health-aware routing,
* HTTPS termination,
* and distribution across multiple application instances.

### Trade-off

The load balancer introduces additional cost and another architectural layer.

For a multi-instance web workload, these costs were justified by the availability and traffic-management benefits.

---

## 9. Use Dedicated Application Health Checks

### Decision

The target group checked:

```text id="7ajmvt"
/health.html
```

over HTTP port 80.

### Why

Load-balancer health should reflect whether the web service is capable of responding successfully rather than only whether an EC2 instance is running.

A dedicated health endpoint allowed the ALB to make routing decisions based on application availability.

### Outcome

Two application targets were validated as healthy before normal traffic delivery.

---

## 10. Terminate HTTPS at the Application Load Balancer

### Decision

AWS Certificate Manager and the ALB HTTPS listener handled external TLS.

HTTP requests were redirected to HTTPS.

### Why

Centralising TLS at the load-balancing layer simplified certificate management and removed the need to manage public certificates independently across replaceable EC2 instances.

### Traffic Model

```text id="yew4tm"
Client
  │
  ▼
HTTP :80
  │
  ▼
Redirect
  │
  ▼
HTTPS :443
  │
  ▼
ALB
  │
  ▼
Private Target Group
```

### Trade-off

Traffic between the ALB and application servers remained internal HTTP in this implementation.

End-to-end TLS could be introduced later if workload requirements demanded encryption between every application layer.

---

## 11. Separate the Month 2B Application Endpoint from the VinceOps Portfolio

### Decision

The Month 2B workload used:

```text id="r7ivsf"
m2b.vinceops.site
```

rather than replacing the existing `vinceops.site` workload.

### Why

The VinceOps portfolio was already hosted separately.

Using a dedicated subdomain allowed the Month 2B infrastructure to be deployed, tested and later decommissioned without disrupting the main portfolio.

### Outcome

The infrastructure experiment remained isolated from the persistent VinceOps public presence.

---

## 12. Store Datadog Credentials in Systems Manager Parameter Store

### Decision

The Datadog API key was stored as a Systems Manager Parameter Store `SecureString`.

### Why

Embedding monitoring credentials directly inside Launch Template User Data would expose a reusable secret inside infrastructure configuration.

Parameter Store allowed the secret to remain separate from the bootstrap script.

### Access Model

```text id="bnfhfz"
EC2 Instance
     │
     ▼
IAM Role
     │
     ▼
SSM GetParameter
     │
     ▼
Encrypted Datadog API Key
```

### Security Benefit

The EC2 workload used IAM-delivered temporary AWS credentials rather than stored AWS access keys.

The published bootstrap script therefore contains no real Datadog credential.

### Trade-off

The bootstrap process now depends on:

* a correctly attached EC2 IAM role,
* the correct SSM parameter path,
* regional access,
* and permission to decrypt/retrieve the parameter.

These dependencies became important during troubleshooting.

---

## 13. Use Datadog for Host-Level Observability

### Decision

Datadog Agents were installed on the VinceOps private web servers.

### Why

The Month 2B architecture needed visibility beyond whether the website could be opened in a browser.

Host telemetry provided direct visibility into infrastructure behaviour such as CPU utilisation.

### Outcome

The web server successfully reported telemetry to Datadog and became available for monitor evaluation.

---

## 14. Route Operational Alerts into Slack

### Decision

Datadog monitor notifications were integrated with the VinceOps `#vinceops-alerts` Slack channel.

### Why

A monitoring system is more useful when significant conditions are surfaced to the operational workflow rather than requiring someone to continually inspect a dashboard.

### Validation

A controlled CPU load test produced:

```text id="y8zoqt"
CPU increase
     ↓
Datadog threshold exceeded
     ↓
Alert condition
     ↓
Slack notification
     ↓
Load removed
     ↓
Datadog recovery
     ↓
Slack recovery notification
```

### Outcome

Both alert and recovery paths were validated.

---

# Architectural Principle

The central Month 2B design principle was:

> **Keep public exposure at the edge, keep application compute private, make compute replaceable, externalise shared state, automate provisioning, and make infrastructure behaviour observable.**

These decisions evolved VinceOps from the Month 2 single-instance model into a stronger platform baseline for later infrastructure work.

---

## Navigate VinceOps Month 2B

[← Month 2B Overview](./README.md) ·
[Architecture](./architecture/) ·
[Engineering Evidence](./evidence/README.md) ·
[Troubleshooting](./troubleshooting.md)

