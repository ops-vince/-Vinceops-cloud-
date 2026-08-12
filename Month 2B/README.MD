# VinceOps Cloud Infrastructure

> An evidence-driven AWS cloud engineering portfolio documenting the progressive infrastructure evolution of a fictional fintech environment.

## VinceOps

VinceOps is a fictional fintech environment used to model the design, implementation, security and operational evolution of AWS infrastructure.

Rather than treating each implementation as an isolated cloud project, the environment develops progressively. Each milestone addresses limitations identified in the previous architecture and introduces stronger security, availability, automation and operational capability.

---

## Engineering Roadmap

| Phase                              | Engineering Focus                                                                                                | Status      |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------- | ----------- |
| [Month 1](./Month%201/)            | AWS Organizations, IAM Identity Center and multi-account access foundation                                       | 🟢 Complete |
| [Month 2](./Month%202/)            | First secure internet-facing workload with VPC, EC2, Nginx, DNS, HTTPS and network visibility                    | 🟢 Complete |
| [Month 2B](./Month%202B/README.MD) | Multi-AZ networking, private compute, shared storage, Auto Scaling, load balancing and operational observability | 🟢 Complete |
| Month 3                            | Terraform Infrastructure as Code and GitHub Actions CI/CD                                                        | ⚪ Upcoming  |
| Month 4                            | Docker, Kubernetes/EKS and container security                                                                    | ⚪ Upcoming  |
| Month 5                            | Platform observability and DevSecOps capstone                                                                    | ⚪ Upcoming  |

---

## Infrastructure Evolution

### Month 1: Cloud Governance and Identity

VinceOps began by establishing the governance and access foundation required for later workloads.

Key areas included:

* AWS Organizations
* separate Development, Staging and Production accounts
* IAM Identity Center
* workforce groups and permission sets
* controlled environment access
* restricted standing access to Production

[Explore Month 1 →](./Month%201/)

---

### Month 2: First Secure Internet-Facing Workload

Month 2 introduced the first public VinceOps workload.

The environment established:

* a custom VPC
* public subnetting and routing
* Internet Gateway connectivity
* EC2 compute
* Nginx
* Route 53 DNS
* HTTPS
* VPC Flow Logs
* external security validation

This proved that VinceOps could securely expose its first AWS-hosted workload.

[Explore Month 2 →](./Month%202/)

---

### Month 2B: High Availability, Private Compute and Observability

Month 2B addressed the limitations of the earlier single-instance architecture.

The VinceOps application environment evolved to include:

* public and private subnets across two Availability Zones
* private EC2 application servers
* bastion-based administrative access
* NAT-based outbound connectivity
* Amazon EFS shared storage
* EC2 Launch Templates
* Auto Scaling
* Application Load Balancing
* application health checks
* Route 53
* AWS Certificate Manager
* HTTP-to-HTTPS redirection
* IAM-based secret access
* Systems Manager Parameter Store
* Datadog infrastructure monitoring
* Slack operational alerting

The infrastructure was also tested under real troubleshooting and controlled load conditions. Application health, bootstrap failures, IAM access, secret retrieval, monitoring integration, alert delivery and recovery were validated before the temporary Month 2B environment was decommissioned.

[Explore Month 2B →](./Month%202B/README.MD)

---

## Infrastructure Progression

```text
Month 1
Cloud governance and access
        |
        v
Month 2
Secure public workload
        |
        v
Month 2B
Multi-AZ private application architecture
        |
        +-- Load balancing
        +-- Auto Scaling
        +-- Shared storage
        +-- Secure secret retrieval
        +-- Monitoring
        +-- Operational alerting
        |
        v
Month 3
Infrastructure as Code and CI/CD
```

The objective is not simply to introduce additional AWS services.

Each VinceOps milestone addresses a new engineering requirement and produces evidence of the resulting architecture, security controls, validation and lessons learned.

---

## Implemented Stack

### AWS

AWS Organizations · IAM Identity Center · IAM · Amazon VPC · Amazon EC2 · EC2 Auto Scaling · Application Load Balancer · Amazon EFS · Amazon S3 · AWS Systems Manager Parameter Store · Amazon Route 53 · AWS Certificate Manager

### Systems and Web

Ubuntu Linux · Amazon Linux 2023 · Nginx · Bash · DNS · HTTPS · Certbot · Let's Encrypt

### Observability and Operations

VPC Flow Logs · Datadog · Slack alerting

### Engineering Workflow

Git · GitHub · architecture documentation · sanitised implementation evidence · troubleshooting records · security validation

---

## Planned Stack

Terraform · GitHub Actions · Docker · Kubernetes/EKS · Trivy · OWASP ZAP · Prometheus · Grafana

---

## Engineering Principles

The VinceOps infrastructure is developed around several recurring principles:

* minimise unnecessary public exposure
* separate public ingress from private application compute
* use identity-based access instead of embedded credentials
* treat application instances as replaceable compute
* externalise shared state where required
* automate repeatable server configuration
* validate application health independently from EC2 state
* monitor infrastructure behaviour
* test alert and recovery paths
* preserve troubleshooting as part of the engineering record

---

## Repository Structure

```text
-Vinceops-cloud-/
|
├── Month 1/
├── Month 2/
├── Month 2B/
│   ├── architecture/
│   ├── evidence/
│   ├── scripts/
│   ├── README.MD
│   ├── decisions.md
│   └── troubleshooting.md
│
├── Month 3/
├── Month 4/
├── Month 5/
└── README.md
```

---

## Evidence-Driven Engineering

VinceOps intentionally preserves more than the final architecture.

Where appropriate, each infrastructure milestone includes:

* architecture decisions
* implementation evidence
* security considerations
* automation
* validation results
* troubleshooting records
* operational lessons

The repository therefore demonstrates both **what was built** and **how the infrastructure was engineered and validated**.

---

## Engineer

**Vince Ifeanyi**
Cloud Security and DevOps Engineer

[LinkedIn](https://www.linkedin.com/in/vinceops) · [Website](https://vinceops.site)

---

> VinceOps is a fictional fintech environment used to demonstrate practical cloud architecture, security, automation and operational engineering. The repository does not represent a continuously operated production financial platform.


---

> This repository documents controlled cloud engineering implementations. VinceOps is a fictional fintech environment used to demonstrate practical AWS architecture, security, automation and operational engineering.
