# IAM Permission-Set Architecture

## Overview

This document describes the AWS IAM Identity Center permission sets implemented for the VinceOps Cloud multi-account environment.

The permission sets were created directly in AWS and define the level of access available to approved workforce groups. They do not grant access independently; access becomes effective only when a permission set is assigned to a group within a specific AWS account.

## Implemented Permission Sets

| Permission Set | Intended Role | Account Scope | Access Approach |
|---|---|---|---|
| `ps-vinceops-dev-devbaseline` | Developers | Development | Baseline visibility for development activities |
| `ps-vinceops-devnonprod-baseline` | DevOps | Development and Staging | Non-production operational visibility |
| `ps-vinceops-security-audit` | Security Auditors | Development and Staging | Security and audit-focused visibility |
| `ps-vinceops-readonly` | ReadOnly users | Development and Staging | Non-modifying resource visibility |
| `ps-vinceops-idgovernance-mgt` | Cloud Administrators | Management | AWS Organizations and IAM Identity Center governance |

## Design Approach

Permission sets were defined before account assignments were created.

The effective access model therefore contains three elements:

1. a workforce group;
2. a permission set;
3. a target AWS account.

Creating a permission set alone does not provide access to an AWS account.

## Conservative Permission Baseline

Developer and DevOps permissions currently use conservative visibility-focused baselines.

Broad write access was intentionally deferred because the environment does not yet contain application workloads, VPC resources, Terraform automation, CI/CD pipelines, databases, containers, or monitoring services.

The current permission sets are therefore initial baselines and are not represented as final resource-level least-privilege policies.

## Provisioning Status

All five permission sets were successfully provisioned through AWS IAM Identity Center.

Service-specific and resource-specific permissions will be introduced only when the relevant AWS workloads and operational requirements are known.

## Related Evidence

See the selected sanitized AWS console evidence:

- [Permission-set evidence](../screenshots/permission%20set%20correct.png)
- [Screenshot evidence guide](../screenshots/Read.md)

## Scope Boundary

This document records the permission-set architecture only.

It does not prove that every cross-account role, trust policy, or Production access path has been reviewed.
