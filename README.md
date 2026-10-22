# VinceOps Cloud Infrastructure Portfolio

> An evidence-driven AWS Cloud and DevOps engineering portfolio built around a fictional fintech startup scenario.

This repository documents the progressive design, implementation, security validation, and deployment of cloud infrastructure using industry-standard DevOps practices.

## Project Overview

VinceOps represents a cloud engineering journey covering:

- AWS infrastructure design and networking
- Identity and access management
- CI/CD concepts and containerization
- Kubernetes orchestration and GitOps
- Infrastructure automation with Terraform
- Monitoring, observability, and security

Each phase contains implementation notes, configuration files, and supporting evidence. Completed laboratory environments are intentionally temporary unless explicitly documented otherwise.

## Repository Structure

| Phase | Project | Status |
|---|---|---|
| 01 | AWS Cloud Foundation | Completed |
| 02 | Networking & Security | Completed |
| 02B | Security Validation & Evidence Collection | Completed |
| 03 | CI/CD Pipeline | Completed |
| 04 | Containerization & Cloud Deployment | Completed |
| 05 | Kubernetes | In progress — Project 01 completed |
| 06 | Infrastructure as Code | Upcoming |
| 07 | Observability & Security Monitoring | Upcoming |

## Completed Projects

### 01 — Cloud Foundation

AWS foundational setup including AWS Organizations, IAM Identity Center, account structure, and initial cloud configuration.

### 02 — Networking & Security

Cloud networking and security foundations including Amazon VPC, EC2 networking, security groups, HTTPS configuration, and S3 security validation.

### 03 — CI/CD Pipeline

Exploration and implementation of automation workflows, GitHub workflow concepts, build automation, and deployment workflow testing.

### 04 — Containerization

A full-stack movie application was containerized and deployed using Docker, React, Spring Boot, MongoDB, AWS EC2, and Amazon ECR.

- [View Containerization Project](./04-Containerization)
- [Deployment Screenshots](./04-Containerization/docs/screenshots)

### 05 — Kubernetes

The Kubernetes phase has started with a temporary single-node K3s cluster on AWS EC2. Project 01 deployed Nginx, verified Service connectivity, scaled replicas, observed Pod replacement, and restored the declared replica count.

- [Kubernetes phase overview](./05-Kubernetes)
- [Project 01 — Kubernetes Fundamentals](./05-Kubernetes/project-01-kubernetes-fundamentals)
- [Project 02 — Declarative Configuration (planned)](./05-Kubernetes/project-02-declarative-configuration)

The EC2 lab used for Project 01 has been terminated. The evidence and manifests are retained in the project documentation package; the cluster is not currently running.

## Technology Stack

### Cloud
- AWS EC2
- Amazon ECR
- Amazon S3
- Amazon VPC
- IAM

### DevOps and Containers
- Docker
- Kubernetes (K3s)
- Helm (planned)
- Argo CD / GitOps (planned)
- GitHub
- Linux Ubuntu

### Infrastructure and Operations
- Terraform (planned for the infrastructure-as-code phase)
- Prometheus and Grafana (planned)
- Security scanning tools (planned)

## Engineering Approach

The repository focuses on:

- Infrastructure documentation and reproducible deployments
- Security-aware cloud practices
- Practical troubleshooting
- Evidence-based implementation
- Clear separation between completed work, planned work, and unverified assumptions
- Cleanup of temporary cloud resources to control costs

## Engineer

**Vince Ifeanyi**  
Cloud Security and DevOps Engineer

LinkedIn: https://www.linkedin.com/in/vinceops  
Website: https://vinceops.site

---

> This repository documents controlled laboratory implementations and engineering projects. It is not presented as a continuously operated production environment.
