# Phase 03 — Continuous Integration Foundations

This phase documents an introductory GitHub Actions exercise: repository checks, workflow execution, and investigation of workflow visibility and Git authentication issues.

## Implemented evidence

- [Phase 03 case study](./README.md)
- [Introductory workflow definition](./workflows/test.yml) (a source example, not an active workflow at this location)
- [Workflow configuration screenshot](./screenshots/workflow-definition.png)
- [Successful GitHub Actions run](./screenshots/workflow-success.png)
- [Troubleshooting record](./troubleshooting.md)

The repository's active workflows are maintained in [`.github/workflows/`](../.github/workflows/). More complete application build and image promotion are documented in [Kubernetes Project 05](../05-Kubernetes/project-05-ci-cd/README.md).

## Scope distinction

This milestone **does not demonstrate Terraform modules, a self-hosted EC2 runner, or S3/DynamoDB state locking**. Terraform provisioning and lifecycle verification are recorded separately in [Phase 06](../06-Infrastructure-as-Code/README.md). These distinctions keep the portfolio's engineering claims aligned with evidence.
