# Phase 06 — AWS Infrastructure as Code with Terraform

This milestone demonstrates declarative AWS provisioning and infrastructure lifecycle management through a completed, temporary Terraform lab in `us-east-1`.

## Project

**[AWS Networking and EC2 Provisioning](./terraform-networking-lab/README.md)** — a custom two-AZ network with four subnets, an Internet Gateway, explicit public/private routes, restricted administrative access, and a public Ubuntu/Nginx instance configured automatically using EC2 user data.

## Observed results

| Lifecycle stage | Verified outcome |
|---|---|
| Provision | 13 initial networking resources created |
| Deploy | EC2 and SSH key pair provisioned; HTTP and SSH access verified |
| Reconcile | Terraform reported no configuration drift |
| Change | EC2 tag updated in place without replacement |
| Teardown | All 17 Terraform-managed resources destroyed |

The implementation and evidence are preserved after teardown; **the lab is not running continuously**. This phase did not provision EKS, an S3 remote-state backend, NAT, or a load balancer.

## Review the implementation

- [Technical case study and architecture](./terraform-networking-lab/README.md)
- [Terraform configuration](./terraform-networking-lab/main.tf)
- [Validation records](./terraform-networking-lab/docs/evidence/validation/)
- [Twelve deployment and lifecycle screenshots](./terraform-networking-lab/docs/evidence/screenshots/README.md)
- [Reproduction and operations reference](./terraform-networking-lab/docs/operations.md)

[Return to the VinceOps portfolio](../README.md)
