# VinceOps Month 2B — Engineering Evidence

This directory contains sanitised implementation and validation evidence from the Month 2B evolution of the VinceOps AWS environment.

Month 2B extended the initial VinceOps workload into a multi-AZ architecture with private application compute, shared storage, automated instance provisioning, load-balanced traffic delivery, HTTPS, infrastructure monitoring, and operational alerting.

The evidence is organised by engineering layer so that individual design decisions and validation results can be reviewed without navigating through an unstructured collection of screenshots.

> **Security note:** Publicly shared evidence has been sanitised to remove credentials, account identifiers, public administrative IP addresses, API keys, email addresses, and other unnecessary sensitive information. Architecture-relevant information such as resource names, ports, CIDR ranges, Availability Zones, and service relationships has been retained where useful.

---

## Evidence index

| Area                                                     | Purpose                                                                                                 |
| -------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| [01 — Networking](./01-networking/)                      | Multi-AZ network layout, internet connectivity, NAT egress, and private routing                         |
| [02 — Security](./02-security/)                          | Layered security-group controls for ingress, administration, and private web access                     |
| [03 — Shared storage](./03-shared-storage/)              | Regional Amazon EFS deployment, access-point configuration, persistent mounting, and shared web content |
| [04 — Compute & Auto Scaling](./04-compute-autoscaling/) | Reusable EC2 launch-template configuration and version evolution                                        |
| [05 — Load balancing](./05-load-balancing/)              | Target health, health-check configuration, and Application Load Balancer delivery                       |
| [06 — DNS & HTTPS](./06-dns-https/)                      | HTTP-to-HTTPS redirection and encrypted application delivery                                            |
| [07 — Observability](./07-observability/)                | Datadog host monitoring, CPU threshold detection, Slack alerting, and recovery                          |
| [08 — Troubleshooting](./08-troubleshooting/)            | Selected implementation validation and troubleshooting evidence                                         |

---

## 01 — Networking

The Month 2B network design separated internet-facing components from the private application tier and distributed resources across two Availability Zones.

| Evidence                                                                                               | What it demonstrates                                                                                                            |
| ------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------- |
| [`01-multi-az-four-subnet-layout.png`](./01-networking/01-multi-az-four-subnet-layout.png)             | Four-subnet design spanning two Availability Zones, with separate public and private network tiers                              |
| [`02-internet-gateway-attached.png`](./01-networking/02-internet-gateway-attached.png)                 | Internet Gateway attached to the VinceOps Month 2B VPC                                                                          |
| [`03-nat-gateway-private-egress.png`](./01-networking/03-nat-gateway-private-egress.png)               | NAT Gateway providing outbound internet access for private workloads without exposing them directly to inbound internet traffic |
| [`04-private-route-through-nat.png`](./01-networking/04-private-route-through-nat.png)                 | Private route table directing `0.0.0.0/0` traffic through the NAT Gateway while retaining local VPC routing                     |
| [`05-private-subnet-route-associations.png`](./01-networking/05-private-subnet-route-associations.png) | Association of both private subnets with the private routing layer                                                              |

---

## 02 — Security

Security controls were implemented around resource relationships rather than exposing the application servers directly to the internet.

| Evidence                                                                                         | What it demonstrates                                                                                                                         |
| ------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------- |
| [`01-alb-inbound-security-policy.png`](./02-security/01-alb-inbound-security-policy.png)         | Internet-facing HTTP ingress terminating at the Application Load Balancer security boundary                                                  |
| [`02-bastion-restricted-ssh-access.png`](./02-security/02-bastion-restricted-ssh-access.png)     | Restricted administrative SSH access through the bastion host                                                                                |
| [`03-private-web-tier-security-group.png`](./02-security/03-private-web-tier-security-group.png) | Private web servers accepting application traffic from the ALB security group and administrative SSH traffic from the bastion security group |

This design kept administrative access and application traffic on separate controlled paths.

---

## 03 — Shared storage

Amazon EFS was introduced so that web instances could operate as replaceable compute nodes while serving common application content.

| Evidence                                                                                               | What it demonstrates                                                                             |
| ------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------ |
| [`01-efs-regional-mount-targets.png`](./03-shared-storage/01-efs-regional-mount-targets.png)           | Regional EFS file system with mount targets available across both application Availability Zones |
| [`02-efs-web-access-point.png`](./03-shared-storage/02-efs-web-access-point.png)                       | Dedicated EFS access point for the VinceOps web content path and POSIX identity configuration    |
| [`03-efs-persistent-mount-validation.png`](./03-shared-storage/03-efs-persistent-mount-validation.png) | Persistent EFS mounting validated through `/etc/fstab`, `mount`, and `findmnt`                   |
| [`04-efs-shared-content-validation.png`](./03-shared-storage/04-efs-shared-content-validation.png)     | Web and health-check content written to and served from the shared storage layer                 |

---

## 04 — Compute & Auto Scaling

The web tier was moved from individually configured instances to a reusable EC2 launch-template model designed for Auto Scaling.

| Evidence                                                                                          | What it demonstrates                                                                          |
| ------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| [`01-launch-template-versioning.png`](./04-compute-autoscaling/01-launch-template-versioning.png) | Reusable web-server configuration and launch-template version evolution during implementation |

Auto Scaling capacity configuration and CPU target-tracking behaviour are documented in the Month 2B implementation narrative and architecture decisions. Only retained screenshot evidence is indexed here.

---

## 05 — Load balancing

The Application Load Balancer became the public entry point for the application while the EC2 fleet remained private.

| Evidence                                                                                                 | What it demonstrates                                                                                                         |
| -------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| [`01-target-group-health-check.png`](./05-load-balancing/01-target-group-health-check.png)               | Application health-check configuration using `/health.html`, HTTP port 80, threshold settings, and HTTP 200 success criteria |
| [`02-target-group-two-healthy-targets.png`](./05-load-balancing/02-target-group-two-healthy-targets.png) | Two application targets registered and reporting healthy                                                                     |
| [`03-workload-served-through-alb.png`](./05-load-balancing/03-workload-served-through-alb.png)           | VinceOps Month 2B application successfully delivered through the Application Load Balancer                                   |

---

## 06 — DNS & HTTPS

Encrypted transport was added at the load-balancer layer while backend web traffic remained internal to the VPC.

| Evidence                                                                                  | What it demonstrates                                                                                                               |
| ----------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| [`01-http-to-https-alb-listeners.png`](./06-dns-https/01-http-to-https-alb-listeners.png) | HTTP listener redirecting requests to HTTPS and HTTPS listener forwarding encrypted client traffic to the application target group |

The Month 2B workload was exposed through the `m2b.vinceops.site` application endpoint during validation.

---

## 07 — Observability

Operational visibility was added so infrastructure conditions could be detected and communicated rather than discovered manually.

| Evidence                                                                                | What it demonstrates                                                                                                                        |
| --------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| [`01-datadog-agent-connected.png`](./07-observability/01-datadog-agent-connected.png)   | Datadog Agent successfully connected and reporting host telemetry                                                                           |
| [`02-datadog-high-cpu-monitor.png`](./07-observability/02-datadog-high-cpu-monitor.png) | Controlled CPU load crossing the configured monitoring threshold and triggering an alert condition                                          |
| [`03-slack-alert-and-recovery.png`](./07-observability/03-slack-alert-and-recovery.png) | Datadog alert delivered to the VinceOps Slack operations channel followed by recovery notification after CPU utilisation returned to normal |

This validated the operational path:

```text
Private EC2 Host
      ↓
Datadog Agent
      ↓
CPU Monitor
      ↓
Threshold Alert
      ↓
Slack #vinceops-alerts
      ↓
Recovery Notification
```

---

## 08 — Troubleshooting

Selected troubleshooting evidence is retained separately from final-state implementation evidence.

This distinction is deliberate: Month 2B included several real configuration and integration failures that were investigated and corrected during the infrastructure evolution. They are documented in greater detail in [`../troubleshooting.md`](../troubleshooting.md).

The troubleshooting record covers areas including:

* EC2 bootstrap failures
* EFS access and persistence validation
* Auto Scaling instance replacement
* IAM and Systems Manager Parameter Store access
* Datadog API-key configuration
* Datadog Agent installation
* Slack notification routing
* controlled CPU-alert validation

---

## Evidence philosophy

The purpose of this evidence is not to document every console click.

It exists to demonstrate that key architectural behaviours were **implemented, tested, observed, and validated**.

The Month 2B evidence therefore focuses on:

* network isolation,
* controlled access paths,
* multi-AZ infrastructure,
* shared application storage,
* reusable compute configuration,
* target health,
* load-balanced delivery,
* encrypted traffic,
* infrastructure observability,
* alert delivery,
* and operational recovery.

---

### VinceOps Cloud

[← Month 2B Overview](../README.md) · [Architecture](../architecture/) · [Engineering Decisions](../decisions.md) · [Troubleshooting](../troubleshooting.md)

