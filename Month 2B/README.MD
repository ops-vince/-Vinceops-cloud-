# VinceOps Cloud — Month 2B

## High Availability, Private Compute & Operational Observability

> **Infrastructure evolution:** moving the VinceOps fintech workload from a single-server deployment to a multi-AZ, privately hosted, load-balanced and observable AWS architecture.

[Architecture](#architecture) ·
[Infrastructure Evolution](#infrastructure-evolution) ·
[Security](#security-design) ·
[High Availability](#high-availability-and-scaling) ·
[Observability](#observability-and-operational-alerting) ·
[Evidence](./evidence/README.md) ·
[Engineering Decisions](./decisions.md) ·
[Troubleshooting](./troubleshooting.md)

---

## Overview

Month 2 established the first secure internet-facing workload for VinceOps.

That milestone proved that the platform could be deployed inside a custom AWS network, served through Nginx, exposed through DNS, protected with HTTPS, and observed at the network layer.

The next engineering question was different:

> **What happens when the workload can no longer depend on one public EC2 instance?**

For a fintech environment, availability, isolation, recovery and operational visibility become increasingly important as the platform matures.

Month 2B therefore evolved the original VinceOps workload into a more resilient architecture built around:

* public and private network tiers across two Availability Zones,
* private EC2 application servers,
* controlled bastion-based administrative access,
* NAT-based outbound access for private workloads,
* shared Amazon EFS storage,
* reusable EC2 Launch Templates,
* an Auto Scaling Group,
* Application Load Balancing,
* target health monitoring,
* Route 53 DNS,
* ACM-managed HTTPS,
* Datadog host monitoring,
* and Slack-based operational alerting.

The infrastructure was built, validated, deliberately stressed, troubleshot and eventually decommissioned after evidence had been captured.

---

# Infrastructure Evolution

Month 2B was not a replacement for Month 2.

It was the next maturity stage of the same VinceOps environment.

### Month 2

```text
Internet
    │
    ▼
Public EC2
    │
    ▼
Nginx
    │
    ▼
vinceops.site
```

The architecture worked, but the application tier still depended on a single internet-facing compute instance.

### Month 2B

```text
                       Internet
                           │
                           ▼
                     Route 53 DNS
                           │
                           ▼
                    HTTPS / AWS ACM
                           │
                           ▼
               Application Load Balancer
                           │
               ┌───────────┴───────────┐
               │                       │
               ▼                       ▼
        Private Web Server      Private Web Server
           us-east-1a              us-east-1b
               │                       │
               └───────────┬───────────┘
                           │
                           ▼
                       Amazon EFS

        Launch Template + Auto Scaling Group

Administrative path:

Engineer
   │
   ▼
Bastion Host
   │
   ▼
Private Web Tier

Observability path:

Private EC2
   │
   ▼
Datadog Agent
   │
   ▼
Datadog Monitor
   │
   ▼
Slack #vinceops-alerts
```

This removed the application servers from direct internet exposure and introduced multiple layers of resilience and operational control.

---

# Architecture

The Month 2B environment was deployed inside a dedicated VinceOps VPC using a four-subnet, two-AZ layout.

| Layer                | Design                                       |
| -------------------- | -------------------------------------------- |
| Region               | AWS US East (N. Virginia)                    |
| Availability Zones   | `us-east-1a`, `us-east-1b`                   |
| Public tier          | Two public subnets                           |
| Private tier         | Two private application subnets              |
| Internet ingress     | Internet Gateway → Application Load Balancer |
| Private egress       | NAT Gateway                                  |
| Administration       | Bastion host                                 |
| Application compute  | Private EC2 fleet                            |
| Shared storage       | Amazon EFS                                   |
| Scaling              | EC2 Auto Scaling                             |
| Traffic distribution | Application Load Balancer                    |
| DNS                  | Amazon Route 53                              |
| TLS                  | AWS Certificate Manager                      |
| Monitoring           | Datadog                                      |
| Alerting             | Slack                                        |

The architecture diagram is maintained in [`architecture/`](./architecture/).

---

# Network Design

The VinceOps VPC was divided into separate public and private network tiers.

Two public and two private subnets were distributed across separate Availability Zones.

The public tier supported internet-facing infrastructure such as the Application Load Balancer, bastion access and NAT connectivity.

The application servers remained inside private subnets and were not assigned public IPv4 addresses.

Private instances reached required external services through the NAT path rather than becoming directly reachable from the internet.

This created a clear separation between:

```text
Public ingress
      ↓
Load-balancing layer
      ↓
Private application tier
```

Implementation evidence is available under [`evidence/01-networking/`](./evidence/01-networking/).

---

# Security Design

Security controls were based primarily on **resource relationships**, rather than broad public-IP access.

The intended traffic model was:

```text
Internet
   │
   ▼
ALB Security Group
   │ HTTP
   ▼
Web Security Group

Administrative workstation
   │ SSH
   ▼
Bastion Security Group
   │ SSH
   ▼
Web Security Group

Web Tier
   │ NFS / 2049
   ▼
EFS Security Group
```

### Application servers remained private

The web instances did not require public IPv4 addresses.

Administrative access passed through the bastion host instead of exposing SSH directly on the application tier.

### Security groups referenced security groups

Where appropriate, inbound rules used source security-group relationships rather than unrestricted CIDR access.

This reduced unnecessary exposure and aligned permissions with application relationships.

### Secrets were separated from automation

The Datadog API key was stored as an encrypted `SecureString` in AWS Systems Manager Parameter Store rather than hard-coded into EC2 User Data.

An EC2 IAM role provided the web tier with temporary AWS credentials for retrieving the required parameter.

No AWS access keys or Datadog credentials were intentionally embedded in the published automation artifact.

Detailed architectural reasoning is documented in [`decisions.md`](./decisions.md).

---

# Shared Storage with Amazon EFS

Auto Scaling creates replaceable compute.

That means application content cannot depend exclusively on the local disk of one EC2 instance.

Amazon EFS was introduced as the shared content layer for the VinceOps web tier.

The implementation included:

* a regional EFS file system,
* mount targets spanning the application Availability Zones,
* a dedicated web access point,
* persistent mounting through `/etc/fstab`,
* TLS-protected EFS mounting,
* retry logic during server bootstrap,
* and shared application content under `/var/www/html`.

This enabled independently launched application instances to serve the same web content.

Evidence is available under [`evidence/03-shared-storage/`](./evidence/03-shared-storage/).

---

# Compute Automation

The application tier was moved away from individually configured EC2 instances.

A reusable EC2 Launch Template defined the server configuration required by the VinceOps web tier.

The bootstrap process handled tasks including:

```text
Instance launch
      ↓
Hostname configuration
      ↓
Application dependencies
      ↓
EFS mounting
      ↓
Nginx configuration
      ↓
Health verification
      ↓
Secure Datadog configuration
      ↓
Agent startup
```

The final portfolio-safe reconstruction of this automation is available at:

[`scripts/web-server-bootstrap.sh`](./scripts/web-server-bootstrap.sh)

Launch Template versioning became particularly important during troubleshooting because configuration changes could be introduced without destroying the previous known-good template.

---

# High Availability and Scaling

The VinceOps application tier was managed by an Auto Scaling Group distributed across two Availability Zones.

The operating configuration used:

```text
Desired capacity: 2
Minimum capacity: 2
Maximum capacity: 4
```

Two instances provided the normal application fleet while the scaling ceiling allowed additional capacity when required.

A CPU target-tracking scaling policy was configured around average CPU utilisation.

This allowed the platform to respond to changing compute demand without relying on manual instance provisioning.

The architecture also demonstrated an important operational principle:

> Application instances should be treated as replaceable infrastructure rather than permanent servers.

During implementation, Auto Scaling replacement behaviour was observed directly as unhealthy or superseded instances were removed and new instances were launched from updated Launch Template versions.

---

# Load Balancing and Health Monitoring

An Application Load Balancer became the public entry point for the Month 2B workload.

The ALB forwarded application traffic to private EC2 targets through a dedicated target group.

The target group used:

```text
Protocol: HTTP
Port: 80
Health endpoint: /health.html
Success code: 200
```

Health checks allowed the load-balancing layer to distinguish healthy application targets from instances that should not receive normal traffic.

The implementation was validated with two registered and healthy application targets.

The workload was also successfully accessed through the ALB endpoint during deployment validation.

Evidence is available under [`evidence/05-load-balancing/`](./evidence/05-load-balancing/).

---

# DNS and HTTPS

The Month 2B workload used the VinceOps DNS namespace without replacing the existing portfolio deployment.

The temporary application endpoint was exposed through:

```text
m2b.vinceops.site
```

while the primary:

```text
vinceops.site
```

continued to serve the VinceOps portfolio independently.

HTTPS was implemented using AWS Certificate Manager and an Application Load Balancer HTTPS listener.

The listener model was:

```text
HTTP :80
   │
   ▼
Redirect
   │
   ▼
HTTPS :443
   │
   ▼
Application Target Group
```

This allowed encryption to terminate at the ALB while application traffic remained internal to the VPC.

Supporting evidence is available under [`evidence/06-dns-https/`](./evidence/06-dns-https/).

---

# Observability and Operational Alerting

Availability is not sufficient if failures remain invisible.

Month 2B therefore introduced infrastructure monitoring and alert delivery.

The operational path was:

```text
Private EC2 Host
      ↓
Datadog Agent
      ↓
Host Metrics
      ↓
CPU Monitor
      ↓
Slack Integration
      ↓
#vinceops-alerts
```

A Datadog Agent was installed on the private web tier and validated as connected and reporting telemetry.

A CPU monitor was then configured with a deliberately low threshold during controlled testing.

CPU utilisation was intentionally increased on a web server, causing the monitor to transition into an alert condition.

The alert was successfully delivered to the VinceOps Slack operations channel.

After the CPU load was stopped, Datadog detected recovery and Slack received the recovery notification.

This validated both sides of the operational lifecycle:

```text
Normal
   ↓
Degradation detected
   ↓
Alert delivered
   ↓
Condition corrected
   ↓
Recovery detected
   ↓
Recovery notification
```

Evidence is available under [`evidence/07-observability/`](./evidence/07-observability/).

---

# Troubleshooting and Engineering Iteration

Month 2B did not follow a perfect happy path.

Several problems emerged during implementation and became part of the engineering work.

Examples included:

* unhealthy Auto Scaling instances,
* Launch Template iteration,
* Amazon Linux 2023 `curl-minimal` package conflicts,
* EC2 bootstrap interruption,
* IAM instance-profile configuration,
* Systems Manager Parameter Store access failure,
* Datadog API credential validation,
* Datadog API Key versus Application Key confusion,
* Agent telemetry validation,
* and Slack monitor-recipient configuration.

The important outcome was not simply that these failures occurred.

Each issue was investigated through observable evidence, reduced to a specific layer, corrected and retested.

The full incident record is maintained in:

[`troubleshooting.md`](./troubleshooting.md)

Selected supporting screenshots are maintained in:

[`evidence/08-troubleshooting/`](./evidence/08-troubleshooting/)

---

# Validation Outcomes

By the end of Month 2B, the VinceOps environment had demonstrated:

* multi-AZ public/private network segmentation,
* private application compute,
* controlled bastion administration,
* NAT-based private outbound access,
* shared EFS-backed application content,
* reusable Launch Template configuration,
* Auto Scaling-managed compute,
* two healthy application targets,
* Application Load Balancer traffic distribution,
* HTTP-to-HTTPS redirection,
* DNS-based application access,
* host-level infrastructure telemetry,
* controlled CPU threshold detection,
* Slack alert delivery,
* and operational recovery notification.

The environment was then deliberately decommissioned after implementation evidence had been captured to prevent unnecessary AWS running costs.

The VinceOps portfolio and its primary Amplify-hosted domain remained separate from the temporary Month 2B workload.

---

# Evidence

Implementation proof is organised by engineering layer rather than as an unstructured screenshot collection.

### [View the Month 2B Engineering Evidence →](./evidence/README.md)

Evidence categories include:

1. Networking
2. Security
3. Shared storage
4. Compute and Auto Scaling
5. Load balancing
6. DNS and HTTPS
7. Observability
8. Troubleshooting

---

# Engineering Decisions

Architecture decisions and trade-offs are documented separately so the main README remains focused on the infrastructure story.

### [Read the Engineering Decisions →](./decisions.md)

Topics include:

* private versus public application compute,
* bastion-based administration,
* Multi-AZ design,
* EFS shared storage,
* Launch Templates and Auto Scaling,
* ALB-based ingress,
* Parameter Store and IAM-based secret retrieval,
* and Datadog/Slack operational visibility.

---

# Repository Layout

```text
Month 2B/
│
├── README.md
├── decisions.md
├── troubleshooting.md
│
├── architecture/
│
├── evidence/
│   ├── README.md
│   ├── 01-networking/
│   ├── 02-security/
│   ├── 03-shared-storage/
│   ├── 04-compute-autoscaling/
│   ├── 05-load-balancing/
│   ├── 06-dns-https/
│   ├── 07-observability/
│   └── 08-troubleshooting/
│
└── scripts/
    └── web-server-bootstrap.sh
```

---

# Engineering Takeaways

Month 2B reinforced several principles that will continue into later VinceOps infrastructure work.

### Availability requires architecture

A healthy EC2 instance is not the same as a highly available application.

Availability depends on eliminating unnecessary single points of failure across compute, networking, storage and traffic delivery.

### Private compute changes the access model

Moving workloads into private subnets requires deliberate thinking around administration, outbound connectivity, load balancing and service dependencies.

### Replaceable compute requires external state

Auto Scaling works best when instances are disposable.

Shared application content therefore needed to live outside individual EC2 root volumes.

### Automation must survive failure

User Data is operational code.

Package assumptions, network dependencies, IAM permissions and secret retrieval all have to be considered when bootstrap automation runs unattended.

### Monitoring must lead to action

Collecting metrics alone does not provide operational readiness.

The monitoring system became useful when an actual infrastructure condition generated an alert for the operations channel and later communicated recovery.

### Troubleshooting is part of the build

Several of the strongest Month 2B lessons came from failures that were not expected.

The environment improved because those failures were investigated rather than hidden.

---

# Month 2B Outcome

Month 2 proved that VinceOps could securely place its first workload on AWS.

**Month 2B proved that the workload could evolve beyond a single server.**

The resulting architecture introduced private application compute, shared storage, automated capacity management, health-aware traffic delivery, encryption, infrastructure telemetry and operational alerting.

This established a stronger infrastructure baseline for the next VinceOps engineering milestone.

---

## Navigate VinceOps

[← Month 2](../Month%202/) ·
[Portfolio Home](../README.md) ·
[Engineering Evidence](./evidence/README.md) ·
[Engineering Decisions](./decisions.md) ·
[Troubleshooting](./troubleshooting.md) ·
[Month 3 →](../Month%203/)

