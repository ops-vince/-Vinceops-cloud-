# Phase 05 — Kubernetes

## Purpose

Learn to operate Kubernetes workloads, manage application configuration declaratively, and package the same application into reusable Helm releases. This phase prepares VinceOps for GitOps, CI/CD integration and eventually Terraform-provisioned infrastructure.

## Progress

| Project | Focus | Status |
|---|---|---|
| [Project 01 — Kubernetes Fundamentals](./project-01-kubernetes-fundamentals/) | K3s, Deployment, ReplicaSet behavior, Pods, ClusterIP Service, scaling and self-healing | Completed and documented |
| [Project 02 — Declarative Configuration](./project-02-declarative-configuration/) | Namespace, ConfigMap-mounted Nginx page, update, rollback, evidence and manifest validation | Practical test completed and documented |
| [Project 03 — Helm](./project-03-helm/) | Chart templates and values, release install, upgrade, ConfigMap propagation, rollback, validation | Practical test completed; documentation prepared |
| Project 04 — Argo CD and GitOps | Reconcile desired state from Git | Planned |
| Project 05 — CI/CD Integration | Image build/publish and deployment changes | Planned |
| Project 06 — Networking and Operations | Ingress, TLS, policy, probes, monitoring and troubleshooting | Planned |

## Architecture progression

```text
Ubuntu WSL -> GitHub -> static manifest validation -> kubectl apply -> K3s (Project 02)
Ubuntu WSL -> GitHub -> Helm chart validation -> helm install/upgrade -> K3s (Project 03)
GitHub -> Argo CD -> Kubernetes (planned Project 04)
Terraform -> repeatable AWS platform infrastructure (later capstone)
```

Helm and Argo CD do not replace Kubernetes; they help manage resources running on Kubernetes. GitHub Actions validation is not proof of a successful live deployment.

## Cost and security

All hands-on clusters used for these exercises are temporary AWS labs. Restrict EC2 SSH to the administrator's IP, avoid exposing the Kubernetes API publicly, and never publish SSH keys or admin kubeconfigs. After each exercise, verify EC2 termination, EBS cleanup and unused public IP allocations.

## Evidence standard

Each completed project's README should distinguish verified command output from expectations, explain troubleshooting, link actual screenshots, and state any remaining limitations or cleanup work.
