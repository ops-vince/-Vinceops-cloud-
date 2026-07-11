# IAM Identity Center Users and Groups

## Overview

VinceOps Cloud uses AWS IAM Identity Center as the centralized workforce identity and access-management service for the AWS Organization.

Access is managed through role-based groups rather than through separate long-term IAM users in each workload account.

## Implemented Workforce Groups

| Group | Responsibility | Intended Account Scope |
|---|---|---|
| `grp-vinceops-developers` | Build and test application services | Development |
| `grp-vinceops-devops` | Support infrastructure operations and future deployment automation | Development and Staging |
| `grp-vinceops-security-auditors` | Review security posture, audit information, and compliance evidence | Development and Staging |
| `grp-vinceops-readonly` | Provide approved operational visibility without modification authority | Development and Staging |
| `grp-vinceops-cloud-administrators` | Manage AWS Organizations and IAM Identity Center | Management |

## Group-Based Access Model

Permission sets are assigned to workforce groups within specific AWS accounts.

Direct user-level permission-set assignments are not part of the documented access model.

This approach supports:

- consistent access administration;
- clearer account-level boundaries;
- simplified onboarding and removal;
- easier access reviews;
- separation between workforce roles and AWS environments.

## Staging Assignment Model

The implemented Staging assignments are:

| Group | Assigned Permission Set |
|---|---|
| `grp-vinceops-devops` | `ps-vinceops-devnonprod-baseline` |
| `grp-vinceops-security-auditors` | `ps-vinceops-security-audit` |
| `grp-vinceops-readonly` | `ps-vinceops-readonly` |

The Developers and Cloud Administrators groups do not have direct IAM Identity Center assignments to Staging.

## Production Boundary

Production has no direct standing IAM Identity Center assignments within the documented model.

This statement applies only to direct IAM Identity Center assignments. It does not prove that every Management-to-Production or cross-account role path has been removed.

## Related Evidence

- [IAM Identity Center groups](../screenshots/Iam-identity-center-groups.png)
- [Staging assignments](../screenshots/Staging%20correct.png)
- [Screenshot evidence guide](../screenshots/Read.md)

## Scope Boundary

Representative workforce-user access-portal testing is not included in the current implementation scope.

The current documentation closes at the administrator-configured group, permission-set, and account-assignment level.
