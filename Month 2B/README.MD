# VinceOps Cloud Infrastructure

> An evidence-driven AWS cloud engineering portfolio built around the progressive infrastructure evolution of a fictional fintech environment.

## VinceOps

VinceOps is a fictional fintech startup used to model the design, implementation, validation and improvement of secure AWS infrastructure.

Rather than treating each implementation as an isolated lab, the environment evolves through successive engineering milestones.

Each stage introduces new operational requirements, architecture decisions, security controls, automation and supporting evidence.

---

## Infrastructure Evolution

| Milestone                 | Engineering Focus                                                                                                  | Status      |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------ | ----------- |
| [Month 1](./Month%201/)   | AWS Organizations, IAM Identity Center and multi-account access foundation                                         | 🟢 Complete |
| [Month 2](./Month%202/)   | First secure internet-facing workload with VPC, EC2, Nginx, DNS, HTTPS and network visibility                      | 🟢 Complete |
| [Month 2B](./Month%202B/) | Multi-AZ architecture, private compute, shared storage, Auto Scaling, load balancing and operational observability | 🟢 Complete |
| Month 3                   | Terraform infrastructure as code and GitHub Actions CI/CD                                                          | ⚪ Upcoming  |
| Month 4                   | Containers, Kubernetes/EKS and container security                                                                  | ⚪ Upcoming  |
| Month 5                   | Platform observability and DevSecOps capstone                                                                      | ⚪ Upcoming  |

---

## Architecture Journey

### Month 1: Cloud Governance Foundation

The VinceOps environment began with an AWS multi-account structure designed around controlled access and separation of responsibilities.

Key areas included:

* AWS Organizations
* separate development, staging and production accounts
* IAM Identity Center
* group-based access
* permission sets
* restricted production access

[View Month 1 →](./Month%201/)

---

### Month 2: First Secure Internet-Facing Workload

Month 2 introduced the first public VinceOps workload.

The environment established:

* a custom VPC
* public subnetting and routing
* Internet Gateway connectivity
* EC2 compute
* Nginx
* DNS
* HTTPS
* VPC Flow Logs
* external security validation

This proved that VinceOps could securely expose its first workload to the internet.

[View Month 2 →](./Month%202/)

---

### Month 2B: Availability, Private Compute and Observability

Month 2B addressed the architectural limitations of the initial single-instance deployment.

The application tier was redesigned around:

* public and private subnets across two Availability Zones
* private EC2 application servers
* bastion-based administrative access
* NAT-based private egress
* Amazon EFS shared storage
* EC2 Launch Templates
* Auto Scaling
* Application Load Balancing
* application health checks
* Route 53
* AWS Certificate Manager
* HTTPS
* Systems Manager Parameter Store
* EC2 IAM roles
* Datadog infrastructure monitoring
* Slack operational alerting

The environment was deliberately tested under failure and load conditions, with troubleshooting and recovery documented as part of the engineering record.

[Explore Month 2B →](./Month%202B/)

---

## Current Architecture Progression

```text
Month 1
Cloud governance and access foundation
        |
        v
Month 2
First secure public workload
        |
        v
Month 2B
Multi-AZ private application platform
        |
        +--> Load balancing
        +--> Auto Scaling
        +--> Shared storage
        +--> Secure secret retrieval
        +--> Monitoring
        +--> Operational alerting
        |
        v
Month 3
Infrastructure as Code and CI/CD
```

The objective is not simply to add AWS services.

Each milestone addresses limitations discovered in the previous architecture and introduces the next level of infrastructure maturity.

---

## Implemented Technology

### AWS

AWS Organizations · IAM Identity Center · IAM · Amazon VPC · Amazon EC2 · Auto Scaling · Application Load Balancer · Amazon EFS · Amazon S3 · AWS Systems Manager Parameter Store · Amazon Route 53 · AWS Certificate Manager

### Infrastructure and Web

Ubuntu Linux · Amazon Linux 2023 · Nginx · Bash · DNS · HTTPS

### Observability and Operations

VPC Flow Logs · Datadog · Slack alerting

### Engineering Workflow

Git · GitHub · architecture documentation · implementation evidence · troubleshooting records · security validation

---

## Engineering Principles

The VinceOps infrastructure is developed around several recurring principles:

* minimise unnecessary public exposure
* separate public ingress from private application compute
* use identity-based access instead of embedded credentials
* design compute to be replaceable
* externalise shared state where required
* automate repeatable configuration
* validate application health independently from instance state
* monitor infrastructure behaviour
* test alert and recovery paths
* document failures as well as successful outcomes

---

## Repository Structure

```text
-Vinceops-cloud-/
|
├── Month 1/
|   └── Cloud governance and access foundation
|
├── Month 2/
|   └── Secure internet-facing workload
|
├── Month 2B/
|   ├── architecture/
|   ├── evidence/
|   ├── scripts/
|   ├── README.md
|   ├── decisions.md
|   └── troubleshooting.md
|
├── Month 3/
├── Month 4/
├── Month 5/
|
└── README.md
```

---

## Evidence-Driven Engineering

This repository intentionally preserves more than final-state architecture.

Where relevant, each milestone includes:

* architecture decisions
* implementation evidence
* validation results
* security considerations
* troubleshooting records
* automation
* and lessons carried forward into later infrastructure work

This makes the repository a record of both **what was built** and **how engineering decisions were reached**.

---

## Engineer

**Vince Ifeanyi**
Cloud Security and DevOps Engineer

[LinkedIn](https://www.linkedin.com/) · [Portfolio](https://vinceops.site)

---

> This repository documents controlled cloud engineering implementations and does not represent a continuously operated production fintech environment.
