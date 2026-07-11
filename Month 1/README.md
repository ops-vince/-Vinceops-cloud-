# Month 1: AWS Multi-Account and IAM Foundation

![AWS](https://img.shields.io/badge/AWS-Organizations-FF9900?logo=amazonaws&logoColor=white)
![IAM](https://img.shields.io/badge/IAM-Identity%20Center-DD344C?logo=amazonaws&logoColor=white)
![Status](https://img.shields.io/badge/Status-Implemented-2EA44F)
![Documentation](https://img.shields.io/badge/Documentation-Complete-0969DA)

> **Built in Amazon Web Services. Documented in GitHub.**

## Project Overview

VinceOps Cloud is a portfolio-based fintech cloud environment designed to demonstrate secure, production-minded AWS architecture.

This milestone establishes the AWS account and workforce identity foundation required before application workloads, networking, infrastructure automation, and deployment pipelines are introduced.

The infrastructure was configured directly in AWS. This repository presents the architecture, access model, technical decisions, and sanitized implementation evidence.

## The Problem

Development, Staging, Production, and organization administration should not operate within one unrestricted AWS account.

Without clearly defined boundaries:

- developers may receive unnecessary access to sensitive environments;
- compromised credentials may affect multiple workloads;
- governance responsibilities may become mixed with workload operations;
- access reviews become difficult to manage;
- Production access may be granted without deliberate approval.

The objective was to establish separate AWS account boundaries and a centralized, role-based workforce access model.

## What I Implemented

- An AWS Organization containing four separate AWS accounts
- A dedicated Management account for organization and identity governance
- Separate Development, Staging, and Production member accounts
- AWS IAM Identity Center for centralized workforce access
- Five role-based workforce groups
- Five centralized permission-set baselines
- Account-specific group and permission-set assignments
- Developer access restricted to Development
- DevOps access restricted to Development and Staging
- Governance access restricted to the Management account
- No direct standing IAM Identity Center assignment to Production

## Explore the Documentation

| Documentation | Description |
|---|---|
| [AWS Organization Documentation](./aws-orginasation/README.md) | Multi-account structure, account purposes, and environment separation |
| [IAM Policies and Permission Sets](./iam-architecture/policies.md) | Permission-set design, access scope, and policy rationale |
| [IAM Users and Groups](./iam-architecture/users-and-groups.md) | Workforce roles, responsibilities, and account assignments |
| [Architecture and Security Decisions](./decisions.md) | Technical decisions, trade-offs, consequences, and review triggers |
| [Sanitized AWS Console Evidence](./screenshots/Read.md) | Selected AWS console evidence supporting the implementation |
| [Full Architecture Diagram](./iam-architecture/Diagram/AWS-Organisation%20account.png) | Visual overview of the implemented AWS Organizations and IAM architecture |

## Architecture Diagram

The diagram below represents the AWS Organizations and IAM Identity Center architecture implemented during this milestone.

[View the full-size architecture diagram](./iam-architecture/Diagram/AWS-Organisation%20account.png)

[![VinceOps Cloud AWS IAM Architecture](./iam-architecture/Diagram/AWS-Organisation%20account.png)](./iam-architecture/Diagram/AWS-Organisation%20account.png)

## AWS Account Architecture

The AWS Organization contains one Management account and three member accounts.

| AWS Account | Responsibility | Assigned Workforce Access |
|---|---|---|
| `Vince` | AWS Organizations, IAM Identity Center, billing, and governance | Cloud Administrators |
| `vinceops-development` | Development and early testing | Developers, DevOps, Security Auditors, and ReadOnly |
| `vinceops-staging` | Pre-production validation and release testing | DevOps, Security Auditors, and ReadOnly |
| `vinceops-production` | Production environment boundary | No direct standing IAM Identity Center assignment |

The Management account is reserved for organization and identity administration. Workload environments are maintained in separate member accounts.

## IAM Identity Center Design

AWS IAM Identity Center provides the centralized workforce access layer for the organization.

Access is managed through:

1. a workforce group;
2. a permission set;
3. a target AWS account.

A permission set does not grant access independently. Access becomes effective only when it is assigned to a workforce group within a specific AWS account.

This separates:

- **who** requires access;
- **what** level of access they receive;
- **where** that access is permitted.

## Workforce Groups

| Workforce Group | Responsibility | Intended Scope |
|---|---|---|
| `grp-vinceops-developers` | Application development and testing | Development |
| `grp-vinceops-devops` | Non-production infrastructure operations | Development and Staging |
| `grp-vinceops-security-auditors` | Security posture and audit visibility | Development and Staging |
| `grp-vinceops-readonly` | Approved non-modifying visibility | Development and Staging |
| `grp-vinceops-cloud-administrators` | AWS Organization and identity governance | Management |

Group-based access was used instead of assigning permissions directly to individual users.

## Permission Sets

| Permission Set | Intended Role | Access Approach |
|---|---|---|
| `ps-vinceops-dev-devbaseline` | Developers | Development visibility baseline |
| `ps-vinceops-devnonprod-baseline` | DevOps | Non-production visibility baseline |
| `ps-vinceops-security-audit` | Security Auditors | Security and audit-focused access |
| `ps-vinceops-readonly` | ReadOnly users | Non-modifying resource visibility |
| `ps-vinceops-idgovernance-mgt` | Cloud Administrators | Organization and identity governance |

The permission sets use conservative, visibility-focused baselines appropriate for the current stage of the environment.

Service-specific permissions can be introduced when actual workloads, resources, actions, and operational requirements are defined.

## Implemented Account Assignments

### Management Account

```text
grp-vinceops-cloud-administrators
└── ps-vinceops-idgovernance-mgt
```

The Cloud Administrators group manages AWS Organizations and IAM Identity Center from the Management account.

### Development Account

```text
grp-vinceops-developers
└── ps-vinceops-dev-devbaseline

grp-vinceops-devops
└── ps-vinceops-devnonprod-baseline

grp-vinceops-security-auditors
└── ps-vinceops-security-audit

grp-vinceops-readonly
└── ps-vinceops-readonly
```

Development provides the broadest non-production workforce access within the implemented model.

### Staging Account

```text
grp-vinceops-devops
└── ps-vinceops-devnonprod-baseline

grp-vinceops-security-auditors
└── ps-vinceops-security-audit

grp-vinceops-readonly
└── ps-vinceops-readonly
```

Developers and Cloud Administrators do not have direct IAM Identity Center assignments to Staging.

### Production Account

```text
No direct standing IAM Identity Center assignment
```

The current Developer, DevOps, Security Auditor, ReadOnly, and Cloud Administrator groups do not receive direct Production access through the documented IAM Identity Center model.

## Key Architecture Decisions

### Multi-Account Isolation

Development, Staging, and Production were separated into individual AWS accounts before introducing workloads.

AWS accounts provide stronger environment boundaries than relying only on resource names, tags, IAM policies, or VPC separation within a single account.

### Management and Workload Separation

The Management account is reserved for AWS Organizations, IAM Identity Center, billing, and governance.

This prevents ordinary workload operations from being mixed with organization-level administration.

### Centralized Workforce Identity

IAM Identity Center was selected to manage workforce groups, permission sets, and AWS account assignments centrally.

This avoids creating separate long-term IAM users across workload accounts.

### Group-Based Access

Permissions are assigned through workforce groups rather than directly to individual identities.

This provides a clearer model for onboarding, role changes, access reviews, and removal of access.

### Conservative Permission Baselines

Broad Developer and DevOps write permissions were intentionally avoided at this stage.

The permission model can be refined into service-specific access when actual workloads and automation requirements are introduced.

### Production Boundary

Production has no direct standing IAM Identity Center assignment.

This establishes a deliberate boundary within the documented workforce access model.

## Implementation Evidence

The repository contains selected, sanitized AWS console screenshots demonstrating:

- the four-account AWS Organization structure;
- the five IAM Identity Center workforce groups;
- the five provisioned permission sets;
- the implemented role-specific Staging assignments.

[Review the sanitized AWS evidence](./screenshots/Read.md)

Sensitive identifiers were removed before publication, including:

- AWS account IDs;
- registered account email addresses;
- AWS Organization identifiers;
- IAM Identity Center instance identifiers;
- permission-set ARNs;
- signed-in account information.

Account names, group names, permission-set names, and provisioning status remain visible because they support the documented architecture.

## Security Statement

The Production claim in this repository is intentionally specific:

> **Production has no direct standing IAM Identity Center assignment.**

This statement applies to the documented IAM Identity Center assignment model. It is not presented as proof that every possible cross-account or Management-to-Production access path has been eliminated.

This distinction keeps the implementation claims aligned with the available AWS configuration and evidence.

## Outcome

This milestone established a centralized, role-based and environment-specific AWS identity foundation.

The resulting architecture provides:

- account-level separation between environments;
- centralized workforce identity management;
- explicit role and permission boundaries;
- controlled non-production access;
- separation of governance and workload responsibilities;
- a clear foundation for future AWS platform services.

---

### Repository Navigation

[⬆ Back to top](#month-1-aws-multi-account-and-iam-foundation) ·
[AWS Organization](./aws-orginasation/README.md) ·
[IAM Policies](./iam-architecture/policies.md) ·
[IAM Groups](./iam-architecture/users-and-groups.md) ·
[Architecture Diagram](./iam-architecture/Diagram/AWS-Organisation%20account.png) ·
[Decisions](./decisions.md) ·
[Evidence](./screenshots/Read.md)
