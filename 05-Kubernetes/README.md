# Phase 05 — Kubernetes

## Purpose

Build practical Kubernetes skills by deploying, inspecting, configuring, and troubleshooting containerized workloads. This phase extends the existing VinceOps containerization work and prepares the platform for Helm, GitOps, and infrastructure automation.

## Status

**In progress.** Project 01 is completed and documented. Project 02 is the next learning project and has not yet been implemented.

## Project Roadmap

| Project | Focus | Status |
|---|---|---|
| [Project 01 — Kubernetes Fundamentals](./project-01-kubernetes-fundamentals/) | K3s, Deployment, ReplicaSet behavior, Pods, Service, scaling, and self-healing | Completed |
| [Project 02 — Declarative Configuration](./project-02-declarative-configuration/) | Namespaces, ConfigMaps, configuration updates, and declarative workflows | Next |
| Project 03 — Helm | Package Kubernetes resources as reusable charts | Planned |
| Project 04 — Argo CD and GitOps | Reconcile desired configuration from Git | Planned |
| Project 05 — CI/CD Integration | Build/publish images and promote version changes | Planned |
| Project 06 — Networking and Operations | Ingress, health probes, access control, and troubleshooting | Planned |

## Architecture Direction

The intended progression is:

```text
Developer workstation (Ubuntu WSL)
          |
          | Git + YAML manifests
          v
       GitHub
          |
          | kubectl apply (early projects)
          v
 Temporary Kubernetes lab (K3s on AWS EC2)
          |
          +--> Deployment --> ReplicaSet --> Pods
          |
          +--> Service --> matching Pod endpoints

Later:
GitHub + Helm charts --> Argo CD / GitOps --> Kubernetes
Terraform --> repeatable AWS infrastructure and platform bootstrap
```

The architecture is built incrementally. Helm, Argo CD, CI/CD integration, and Terraform are not claimed as implemented in Project 01.

## Cost and Security Approach

- Use temporary AWS resources only for hands-on tasks that require a running cluster.
- Verify the AWS Region, instance type, public-IP configuration, and security group before launch.
- Restrict SSH to the administrator's current IP address; do not expose the Kubernetes API publicly.
- Capture evidence and terminate temporary compute resources after the lab.
- Verify that unused EBS volumes and public IP allocations are not left behind.
- Never commit private keys, credentials, or real Secret values.

## Evidence

Project-specific commands, manifests, results, and screenshots are recorded in each project's directory.
