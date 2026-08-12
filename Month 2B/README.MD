# VinceOps Cloud Infrastructure

> An evidence-driven AWS cloud engineering portfolio built around the progressive infrastructure evolution of a fictional fintech environment.

## The Scenario

VinceOps is a fictional fintech startup used to model the design, implementation, security and operational evolution of AWS infrastructure.

The environment develops progressively. Each milestone builds on the previous one and documents the architecture, engineering decisions, security controls, implementation evidence and lessons carried forward.

---

## Engineering Roadmap

| Phase                     | Infrastructure Focus                                                                              | Status      |
| ------------------------- | ------------------------------------------------------------------------------------------------- | ----------- |
| [Month 1](./Month%201/)   | AWS Organizations, IAM Identity Center and multi-account access foundation                        | 🟢 Finished |
| [Month 2](./Month%202/)   | VPC, EC2, Nginx, DNS, HTTPS, VPC Flow Logs and external security validation                       | 🟢 Finished |
| [Month 2B](./Month%202B/) | Multi-AZ networking, private compute, EFS, Auto Scaling, ALB, HTTPS and operational observability | 🟢 Finished |
| Month 3                   | Terraform Infrastructure as Code and GitHub Actions CI/CD                                         | ⚪ Upcoming  |
| Month 4                   | Docker, Kubernetes/EKS and container security                                                     | ⚪ Upcoming  |
| Month 5                   | Platform observability and DevSecOps capstone                                                     | ⚪ Upcoming  |

---

## Infrastructure Evolution

### Month 1: Cloud Governance and Identity

The VinceOps foundation began with AWS account separation and centralised workforce access.

Key areas:

* AWS Organizations
* separate Development, Staging and Production accounts
* IAM Identity Center
* workforce groups and permission sets
* restricted environment access
* no standing Production assignment

[Explore Month 1 →](./Month%201/)

---

### Month 2: First Secure Internet-Facing Workload

The next milestone introduced the first VinceOps workload on AWS.

Key areas:

* custom VPC networking
* EC2 compute
* Nginx
* Route 53 DNS
* HTTPS
* VPC Flow Logs
* external security validation

This established the first secure public application path for VinceOps.

[Explore Month 2 →](./Month%202/)

---

### Month 2B: High Availability, Private Compute and Observability

Month 2B addressed the limitations of the earlier single-instance workload.

The architecture evolved to include:

* public and private subnets across two Availability Zones
* private EC2 application servers
* controlled bastion administration
* NAT-based private egress
* Amazon EFS shared storage
* EC2 Launch Templates
* Auto Scaling
* Application Load Balancing
* application health checks
* Route 53 and ACM-managed HTTPS
* IAM-based secret access through Systems Manager Parameter Store
* Datadog infrastructure monitoring
* Slack operational alerting

The environment was validated under real troubleshooting and controlled load conditions, including application health, bootstrap failures, IAM access, monitoring integration, alert delivery and recovery.

[Explore Month 2B →](./Month%202B/)

---

## Current Progression

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
        +--> Load balancing
        +--> Auto Scaling
        +--> Shared storage
        +--> Secure secret retrieval
        +--> Monitoring and alerting
        |
        v
Month 3
Infrastructure as Code and CI/CD
```

Each milestone addresses limitations identified in the previous stage rather than functioning as an isolated AWS exercise.

---

## Implemented Stack

**AWS**

AWS Organizations · IAM Identity Center · IAM · Amazon VPC · Amazon EC2 · EC2 Auto Scaling · Application Load Balancer · Amazon EFS · Amazon S3 · Systems Manager Parameter Store · Amazon Route 53 · AWS Certificate Manager

**Systems and Web**

Ubuntu Linux · Amazon Linux 2023 · Nginx · Bash · DNS · HTTPS · Certbot · Let's Encrypt

**Observability and Operations**

VPC Flow Logs · Datadog · Slack alerting

**Engineering Workflow**

Git · GitHub · architecture documentation · sanitised implementation evidence · troubleshooting records · security validation

---

## Planned Stack

Terraform · GitHub Actions · Docker · Kubernetes/EKS · Trivy · OWASP ZAP · Prometheus · Grafana

---

## Engineering Approach

VinceOps is developed around a consistent set of principles:

* minimise unnecessary public exposure
* separate public ingress from private application compute
* use identity-based access instead of embedded credentials
* design application instances to be replaceable
* externalise shared state where required
* automate repeatable configuration
* validate application health independently from EC2 state
* monitor infrastructure behaviour
* test both alert and recovery paths
* preserve troubleshooting as part of the engineering record

---

## Engineer

**Vince Ifeanyi**
Cloud Security and DevOps Engineer

[LinkedIn](https://www.linkedin.com/in/vinceops) · [Website](https://vinceops.site)

---

> This repository documents controlled cloud engineering implementations. VinceOps is a fictional fintech environment used to demonstrate practical AWS architecture, security, automation and operational engineering.
