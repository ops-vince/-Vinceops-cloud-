# Month 1: AWS Multi-Account and IAM Foundation

> **Implementation Platform:** Amazon Web Services  
> **Documentation Platform:** GitHub  
> **AWS Organizations and IAM Scope:** Complete  
> **Completed Implementation:** Parts 1–4  
> **End-User Access-Portal Validation:** Not included in the current scope  
> **VPC Foundation:** Pending  

## Overview

This repository documents the AWS multi-account and IAM foundation implemented for VinceOps Cloud.

The infrastructure was configured directly within Amazon Web Services. GitHub is used only to organize and present the architecture documentation, implementation decisions, diagrams, and sanitized AWS console evidence.

The implementation establishes separate AWS environments and a centralized workforce access model before the introduction of application workloads, networking, infrastructure as code, CI/CD pipelines, containers, or monitoring services.

## Business Context

VinceOps Cloud is a simulated fintech cloud environment designed to demonstrate production-minded AWS architecture, environment isolation, centralized workforce identity, and controlled account access.

The objective of this phase was to establish the AWS organization and IAM foundation before application and network resources are introduced.

## Implemented Scope

The following controls were implemented in AWS:

- An AWS Organization containing Management, Development, Staging, and Production accounts
- Separation of governance activities from workload environments
- AWS IAM Identity Center as the centralized workforce identity service
- Five role-based workforce groups
- Five permission-set baselines
- Management-account identity-governance access
- Development account assignments for approved workforce groups
- Staging account assignments for approved non-production roles
- No direct standing IAM Identity Center assignments to Production

## Implementation Phases

| Part | Implementation Area | Status |
|---|---|---|
| Part 1 | AWS Organization and account separation | Complete |
| Part 2 | IAM Identity Center and workforce groups | Complete |
| Part 3 | Permission-set baselines | Complete |
| Part 4 | Account-specific access assignments | Complete |
| Part 5 | MFA test identities and access-portal validation | Excluded from current scope |

## AWS Account Model

| Account | Primary Purpose | Current Workforce Access |
|---|---|---|
| Management | AWS Organizations, IAM Identity Center, billing, and governance | Cloud Administrators |
| Development | Application development and early testing | Developers, DevOps, Security Auditors, and ReadOnly |
| Staging | Pre-production validation and release testing | DevOps, Security Auditors, and ReadOnly |
| Production | Future customer-facing workloads | No direct standing IAM Identity Center assignment |

## Production Access Statement

Production has no direct standing IAM Identity Center user or group assignments within the documented access model.

This statement applies specifically to IAM Identity Center assignments. It is not represented as proof that every possible Management-to-Production or cross-account access path has been removed.

The default `OrganizationAccountAccessRole` and any future cross-account role relationships require separate review before a broader Production-isolation claim can be made.

## Permission Strategy

The current Developer and DevOps permission sets use conservative visibility-focused baselines.

Broad write permissions were intentionally not introduced because the project does not yet contain:

- application workloads;
- VPC resources;
- Terraform-managed infrastructure;
- CI/CD pipelines;
- container platforms;
- databases;
- monitoring services.

The current permission sets are therefore documented as initial baselines rather than final resource-level least-privilege policies.

Service-specific permissions should be introduced only when the required AWS services, actions, resources, and security conditions are known.

## Documentation Structure

- [AWS Organization Documentation](./aws-organisation/)
- [IAM Policies and Permission Sets](./iam-architecture/policies.md)
- [IAM Users and Groups](./iam-architecture/users-and-groups.md)
- [Architecture and Security Decisions](./decisions.md)
- [Sanitized AWS Console Evidence](./screenshots/Read.md)

## Scope Boundary

This repository currently documents the AWS Organizations and IAM Identity Center implementation only.

The following items are not represented as implemented:

- IAM Identity Center end-user access-portal validation
- Approved temporary Production elevation
- Break-glass Production access
- Service control policies
- VPC architecture
- Application workloads
- Terraform
- CI/CD pipelines
- Kubernetes
- Centralized monitoring and logging

## Current Status

The AWS Organizations and IAM implementation documented in Parts 1–4 is complete.

End-user access-portal testing is not included in the current implementation scope.

If the wider Month 1 plan still includes the VPC foundation, Month 1 remains in progress until the network design is implemented, validated, diagrammed, and documented.

## Evidence Standard

All public screenshots must:

- hide AWS account IDs;
- hide registered account email addresses;
- hide IAM Identity Center access-portal URLs;
- hide personal information;
- hide temporary passwords and authentication secrets;
- hide MFA QR codes and recovery information;
- keep relevant account, group, and permission-set names visible.

No implementation claim should be stronger than the available AWS configuration and sanitized evidence support.

## Next Technical Phase

The next technical phase is the AWS VPC foundation, including:

- public and private subnet separation;
- route-table design;
- controlled internet access;
- environment-specific network boundaries;
- network architecture documentation;
- validation evidence.
