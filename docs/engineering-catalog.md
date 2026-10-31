# VinceOps — Engineering Portfolio Review Guide

This guide provides a consistent review path through the implemented work. VinceOps is a **simulated fintech engineering portfolio**, not an always-on production system. The recorded AWS and Kubernetes labs were completed as separate exercises; their architecture diagrams describe the relevant lab environments, not a single integrated deployment.

## Engineering milestones

| Phase | Engineering problem | Demonstrated implementation | Start with |
|---|---|---|---|
| **01 — Cloud foundation** | Separate workload environments and govern access | AWS Organizations account separation, IAM Identity Center groups, permission sets and account assignments | [Architecture and decisions](../01-Cloud-Foundation/README.md) |
| **02 — Networking and secure web** | Host a public website within a controlled AWS network | VPC/subnet routing, EC2 and Nginx, DNS and HTTPS, VPC Flow Logs, exposure checks | [Architecture and evidence](../02-Networking-Security/README.md) |
| **02B — Private infrastructure** | Introduce isolation, resilience and operational visibility | Multi-AZ design, private compute, ALB, NAT, EFS, security boundaries and monitoring exercises | [Architecture and validation](../02B-Security-Validation/README.md) |
| **03 — CI foundations** | Make source checks repeatable and observable | Introductory GitHub Actions checks, pipeline troubleshooting and recorded workflow results | [CI implementation](../03-CI-CD-Pipeline/README.md) |
| **04 — Containerized delivery** | Package and test a multi-service application | React/Nginx, Spring Boot and MongoDB Docker/EC2 lab; ECR image publication and service checks | [Application architecture and deployment evidence](../04-Containerization/README.md) |
| **05 — Kubernetes engineering** | Manage deployment state, releases and access controls | Six K3s projects: workloads, ConfigMaps, Helm, Argo CD, GHCR delivery, Ingress and security | [Project directory and evidence](../05-Kubernetes/README.md) |
| **06 — Terraform** | Define, reconcile and remove AWS infrastructure as code | Two-AZ VPC with four subnets, IGW/route tables, restricted SSH, EC2/Nginx, idempotency, in-place change, teardown | [Terraform case study](../06-Infrastructure-as-Code/terraform-networking-lab/README.md) |

## Engineering evidence — selected entry points

**AWS and IAM:** [Cloud foundation screenshots](../01-Cloud-Foundation/screenshots/README.md) and [account architecture](../01-Cloud-Foundation/README.md).

**Public AWS networking:** [Phase 02 evidence gallery](../02-Networking-Security/screenshots/README.md) and [architecture diagram](../02-Networking-Security/diagrams/network-web-architecture.png).

**Private AWS infrastructure:** [Phase 02B evidence index](../02B-Security-Validation/evidence/README.md) and [troubleshooting record](../02B-Security-Validation/troubleshooting.md).

**GitHub Actions:** [CI foundation](../03-CI-CD-Pipeline/README.md) and [active workflow definitions](../.github/workflows/).

**Application delivery:** [Phase 04 deployment record](../04-Containerization/docs/deployment.md) and [screenshots](../04-Containerization/docs/screenshots/).

**Kubernetes:** [Six-project overview](../05-Kubernetes/README.md); each project README links to its own source and validation evidence.

**Terraform:** [Twelve original screenshots](../06-Infrastructure-as-Code/terraform-networking-lab/docs/evidence/screenshots/README.md), [five validation reports](../06-Infrastructure-as-Code/terraform-networking-lab/docs/evidence/validation/), and a separate [operations reference](../06-Infrastructure-as-Code/terraform-networking-lab/docs/operations.md).

## Architectural and evidentiary boundaries

- **Workload environments:** AWS and K3s labs were temporary. Historical screenshots do not establish current service availability.
- **Availability:** A two-Availability-Zone subnet layout is not evidence of a highly available application when only a single application instance was deployed.
- **CI/CD:** The introductory workflow in Phase 03 is not equivalent to the later GitHub Actions/GHCR/Argo CD pipeline in Phase 05.
- **Networking security:** Static NetworkPolicy schema validation and a blocked probe do not independently establish enforcement across every traffic path; see the Project 06 limitations.
- **Terraform:** Phase 06 used local state and an AWS SSO profile; it is not a demonstration of remote-state locking or EKS provisioning. The verified result was 17 managed resources destroyed.
- **Application provenance:** The movie application contains third-party learning/reference components. Their source is credited in the component READMEs; the VinceOps contribution centers on platform engineering.
- **Reproducibility:** Source files, historical evidence and successful CI logs should be distinguished from a fresh build on the current commit. A backend Dockerfile correction is proposed separately and requires validation.

## Review approach

Read the root [portfolio overview](../README.md) for scope and progression, choose a phase above, then inspect the project architecture, source artifacts, verification records and stated limitations. Where an implementation was tested and subsequently deleted, the evidence records preserve the observed result rather than implying ongoing uptime.
