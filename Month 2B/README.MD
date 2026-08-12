# VinceOps Cloud Infrastructure

> An evidence-driven AWS cloud engineering portfolio documenting the progressive infrastructure evolution of a fictional fintech environment.

## The Scenario

VinceOps is a fictional fintech environment used to model secure, scalable and operationally mature AWS infrastructure.

The environment is developed progressively. Each milestone builds on the previous one and records the architecture, engineering decisions, security controls, implementation evidence and lessons learned.

## Engineering Roadmap

| Phase                                                                          | Engineering Focus                                                                                                | Status      |
| ------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------- | ----------- |
| [Month 1](https://github.com/ops-vince/-Vinceops-cloud-/tree/main/Month%201)   | AWS Organizations, IAM Identity Center and multi-account access foundation                                       | 🟢 Complete |
| [Month 2](https://github.com/ops-vince/-Vinceops-cloud-/tree/main/Month%202)   | First secure internet-facing workload with VPC, EC2, Nginx, DNS, HTTPS and network visibility                    | 🟢 Complete |
| [Month 2B](https://github.com/ops-vince/-Vinceops-cloud-/tree/main/Month%202B) | Multi-AZ networking, private compute, shared storage, Auto Scaling, load balancing and operational observability | 🟢 Complete |
| Month 3                                                                        | Terraform Infrastructure as Code and GitHub Actions CI/CD                                                        | ⚪ Upcoming  |
| Month 4                                                                        | Docker, Kubernetes/EKS and container security                                                                    | ⚪ Upcoming  |
| Month 5                                                                        | Platform observability and DevSecOps capstone                                                                    | ⚪ Upcoming  |

## Infrastructure Evolution

### Month 1: Cloud Governance and Identity

VinceOps began by establishing its AWS governance and workforce-access foundation.

Key areas included:

* AWS Organizations
* Development, Staging and Production account separation
* IAM Identity Center
* workforce groups and permission sets
* controlled environment access
* restricted standing Production access

[Explore Month 1](https://github.com/ops-vince/-Vinceops-cloud-/tree/main/Month%201)

### Month 2: First Secure Internet-Facing Workload

Month 2 introduced the first public VinceOps workload.

The environment established:

* custom VPC networking
* EC2 compute
* Nginx
* Route 53 DNS
* HTTPS
* VPC Flow Logs
* external security validation

This established the first secure public application path for VinceOps.

[Explore Month 2](https://github.com/ops-vince/-Vinceops-cloud-/tree/main/Month%202)

### Month 2B: High Availability, Private Compute and Observability

Month 2B addressed the limitations of the earlier single-instance architecture.

The environment evolved to include:

* public and private subnets across two Availability Zones
* private EC2 application servers
* bastion-based administrative access
* NAT-based private egress
* Amazon EFS shared storage
* EC2 Launch Templates
* Auto Scaling
* Application Load Balancing
* application health checks
* Route 53 and ACM-managed HTTPS
* IAM-based secret retrieval through Systems Manager Parameter Store
* Datadog infrastructure monitoring
* Slack operational alerting

The infrastructure was tested through real troubleshooting and controlled load conditions, including application health, bootstrap failures, IAM access, monitoring integration, alert delivery and recovery.

[Explore Month 2B](https://github.com/ops-vince/-Vinceops-cloud-/tree/main/Month%202B)

## Infrastructure Progression

```text
Month 1
Cloud governance and identity
        |
        v
Month 2
First secure public workload
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

Each milestone addresses a new VinceOps engineering requirement rather than functioning as an isolated AWS exercise.

## Implemented Stack

### AWS

AWS Organizations · IAM Identity Center · IAM · Amazon VPC · Amazon EC2 · EC2 Auto Scaling · Application Load Balancer · Amazon EFS · Amazon S3 · AWS Systems Manager Parameter Store · Amazon Route 53 · AWS Certificate Manager

### Systems and Web

Ubuntu Linux · Amazon Linux 2023 · Nginx · Bash · DNS · HTTPS · Certbot · Let's Encrypt

### Observability and Operations

VPC Flow Logs · Datadog · Slack alerting

### Engineering Workflow

Git · GitHub · architecture documentation · sanitised implementation evidence · troubleshooting records · security validation

## Planned Stack

Terraform · GitHub Actions · Docker · Kubernetes/EKS · Trivy · OWASP ZAP · Prometheus · Grafana

## Engineering Principles

* minimise unnecessary public exposure
* separate public ingress from private application compute
* use identity-based access instead of embedded credentials
* treat application instances as replaceable compute
* externalise shared state where required
* automate repeatable configuration
* validate application health independently from EC2 state
* monitor infrastructure behaviour
* test alert and recovery paths
* preserve troubleshooting as part of the engineering record

## Engineer

**Vince Ifeanyi**
Cloud Security and DevOps Engineer

[LinkedIn](https://www.linkedin.com/in/vinceops) · [Website](https://vinceops.site)

---

> VinceOps is a fictional fintech environment used to demonstrate practical cloud architecture, security, automation and operational engineering. This repository does not represent a continuously operated production financial platform.
