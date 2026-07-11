# AWS Organisation and IAM Architecture Decisions

## Document Purpose

This document records the principal architecture and security decisions made during the VinceOps Cloud AWS Organizations and IAM Identity Center implementation.

The infrastructure described in this document was implemented directly in Amazon Web Services. GitHub is used only to preserve and present the documentation, architecture decisions, diagrams, and sanitized implementation evidence.

This decision record explains why each control was selected, its current status, its consequences, and the conditions under which it should be reviewed.

---

## Decision Status

| Status | Meaning |
|---|---|
| Accepted | The decision has been approved and implemented in AWS. |
| Planned | The decision has been accepted but has not yet been implemented. |
| Excluded | The item is intentionally outside the current implementation scope. |
| Superseded | The decision has been replaced by a later decision. |

---

# Part 1: AWS Organisation and Account Boundary

## ADR-001: Use a Multi-Account AWS Organisation

**Status:** Accepted

### Context

VinceOps Cloud requires clear separation between governance activities, development workloads, staging validation, and future production workloads.

Using a single AWS account for all environments would place unrelated resources within the same administrative and security boundary.

### Decision

Use AWS Organizations with four separate AWS accounts:

- Management
- Development
- Staging
- Production

Each environment is maintained within its own AWS account.

### Rationale

AWS accounts provide a stronger isolation boundary than separating environments only through resource names, tags, IAM policies, security groups, or VPCs inside a single account.

The multi-account structure also creates a foundation for future:

- service control policies;
- centralized logging;
- security monitoring;
- account-specific billing;
- network segmentation;
- controlled deployments;
- production governance.

### Consequences

- Each member account requires a unique registered email address.
- Account access must be granted explicitly.
- Cross-account roles and trust relationships must be reviewed carefully.
- Future networking, monitoring, and deployment designs must support multiple accounts.

### Review Trigger

Review this decision if additional workloads, teams, shared services, regulatory requirements, or organizational units require further account separation.

---

## ADR-002: Reserve the Management Account for Governance

**Status:** Accepted

### Context

The AWS Organizations Management account controls the organization and has elevated administrative responsibility.

Placing ordinary application workloads in the Management account would unnecessarily expose the organization control plane.

### Decision

Use the Management account only for:

- AWS Organizations administration;
- IAM Identity Center administration;
- billing;
- governance;
- future centralized audit and security functions.

Application workloads will not be deployed in the Management account.

### Rationale

Separating governance from workloads reduces the risk that application activity, deployment failures, or operational mistakes affect the organization control plane.

### Consequences

- Application resources must be deployed only in approved member accounts.
- Management-account permissions must remain tightly controlled.
- Administrative identities require stronger review than normal workload identities.
- Centralized services must be evaluated carefully before being placed in the Management account.

### Review Trigger

Review this decision before adding centralized logging, networking, security, or shared-service resources to the Management account.

---

# Part 2: Centralized Workforce Identity

## ADR-003: Use IAM Identity Center for Workforce Access

**Status:** Accepted

### Context

Creating separate IAM users in Development, Staging, and Production would duplicate identity administration and increase dependence on long-term credentials.

### Decision

Use AWS IAM Identity Center as the centralized workforce identity and access-management service for the AWS Organization.

Normal workforce access will not be provided through independently created IAM users in workload accounts.

### Rationale

IAM Identity Center centralizes the management of:

- users;
- groups;
- permission sets;
- AWS account assignments;
- workforce authentication;
- future MFA controls.

This creates a clearer and more manageable workforce access model.

### Consequences

- Workforce access depends on explicit IAM Identity Center assignments.
- User and group administration is performed centrally.
- The selected IAM Identity Center Region becomes an architectural dependency.
- Local IAM users should be avoided unless a specific exception is justified.

### Review Trigger

Review this decision if an external identity provider, enterprise directory, or automated user-lifecycle platform becomes available.

---

## ADR-004: Use the IAM Identity Center Directory as the Initial Identity Source

**Status:** Accepted

### Context

VinceOps Cloud does not currently use an enterprise identity provider such as Microsoft Entra ID, Okta, or another external workforce directory.

### Decision

Use the built-in IAM Identity Center directory as the initial identity source.

External federation is deferred until there is a valid organizational or technical requirement.

### Rationale

The built-in directory supports the current implementation without introducing an external dependency that cannot yet be justified, maintained, or validated.

### Consequences

- Workforce identities must currently be created within IAM Identity Center.
- User lifecycle management remains manual.
- External federation and automated provisioning are future improvements.
- Controlled email addresses or aliases would be required for future user activation and testing.

### Review Trigger

Review this decision when the project introduces an enterprise directory, automated identity lifecycle, or single sign-on requirement.

---

## ADR-005: Use Role-Based Workforce Groups

**Status:** Accepted

### Context

Assigning AWS access directly to individual users would make access reviews, role changes, and permission management difficult to scale.

### Decision

Use the following role-based workforce groups:

- `grp-vinceops-developers`
- `grp-vinceops-devops`
- `grp-vinceops-security-auditors`
- `grp-vinceops-readonly`
- `grp-vinceops-cloud-administrators`

Access is granted through group membership rather than direct user-level account assignments.

### Rationale

Group-based access:

- improves consistency;
- simplifies onboarding and removal;
- supports clearer access reviews;
- separates workforce identity from permission design;
- reduces individual configuration.

### Consequences

- Direct permission assignments to individual users are discouraged.
- Group membership becomes a security-sensitive control.
- Access reviews must examine both group membership and account assignments.
- New groups should be introduced only where a distinct responsibility exists.

### Review Trigger

Review this decision when new workforce responsibilities require a materially different access pattern.

---

# Part 3: Permission-Set Baselines

## ADR-006: Define Permission Sets Before Granting Account Access

**Status:** Accepted

### Context

A permission set defines what a role can do, while an account assignment defines where that role can operate.

Combining these concerns without separate review could create unintended access.

### Decision

Create and review permission sets before assigning workforce groups to AWS accounts.

A permission set is not treated as active access until it is combined with:

1. a workforce group;
2. a target AWS account;
3. an explicit account assignment.

### Rationale

Separating permission design from account assignment allows the access model to be reviewed before it becomes effective.

### Consequences

- Creating a permission set does not automatically grant access.
- Account assignments must be reviewed separately.
- Each effective access path must be traceable to a group, permission set, and target account.
- Future automation must preserve this separation.

### Review Trigger

Review this decision when Terraform, automated IAM provisioning, or deployment pipelines are introduced.

---

## ADR-007: Begin with Conservative Permission Baselines

**Status:** Accepted

### Context

The environment does not yet contain VPCs, application workloads, Terraform-managed resources, CI/CD pipelines, databases, container platforms, or monitoring services.

Granting broad write access before those services exist would be speculative and difficult to justify.

### Decision

Use conservative visibility-focused AWS managed policies as temporary permission-set baselines.

The initial design uses policies such as:

- `ViewOnlyAccess`;
- `SecurityAudit`;
- governance-specific AWS managed policies.

### Rationale

The objective of the current phase is to establish the identity and environment-access model without granting unnecessary modification authority.

Service-specific permissions should be introduced only when the actual services, actions, resources, and security conditions are known.

### Consequences

- The current permission sets are baseline controls rather than final least-privilege policies.
- Broad Developer and DevOps write permissions remain intentionally absent.
- AWS managed policies must be reviewed because their contents can change.
- Future workloads will require narrower, service-specific policies.

### Review Trigger

Review this decision when VPC resources, workloads, Terraform, CI/CD, databases, containers, or monitoring services are introduced.

---

## ADR-008: Restrict Identity Governance Permissions to Management

**Status:** Accepted

### Context

AWS Organizations and IAM Identity Center administration are governance responsibilities and should not be combined with ordinary workload operations.

### Decision

Assign the identity-governance permission set only to the Cloud Administrators group in the Management account.

Do not assign the Management governance permission set to Development, Staging, or Production.

### Rationale

This maintains separation between organization control-plane administration and workload access.

### Consequences

- Workload administration will require separate permission sets.
- The Management permission set must be reviewed for unnecessary privileges.
- Management-account access does not automatically prove that every cross-account access path is controlled.

### Review Trigger

Review this decision whenever additional governance policies, administrative services, or cross-account capabilities are introduced.

---

# Part 4: Account-Level Access Assignments

## ADR-009: Use Account-Specific Group Assignments

**Status:** Accepted

### Context

Workforce roles do not require identical access across every AWS environment.

Developers require Development access, while DevOps and security-related roles require visibility across selected non-production environments.

### Decision

Grant access through explicit group-to-permission-set-to-account assignments.

The implemented model is:

| AWS Account | Approved Workforce Access |
|---|---|
| Management | Cloud Administrators |
| Development | Developers, DevOps, Security Auditors, ReadOnly |
| Staging | DevOps, Security Auditors, ReadOnly |
| Production | No direct standing IAM Identity Center assignment |

### Rationale

Account-specific assignments create a clear separation between job responsibility and environment scope.

### Consequences

- Access must be reviewed independently for each AWS account.
- Creating a group or permission set does not provide access by itself.
- A role added to another environment requires a deliberate architectural decision.
- Production remains outside the standing IAM Identity Center assignment model.

### Review Trigger

Review this decision whenever a role requires access to an additional AWS account.

---

## ADR-010: Limit Developers to Development

**Status:** Accepted

### Context

Developers require an environment for application development and early testing.

No current requirement justifies standing Developer access to Management, Staging, or Production.

### Decision

Assign the Developers group only to the Development account.

### Rationale

This establishes a clear separation between development activity and later-stage operational environments.

### Consequences

- Developers do not receive direct IAM Identity Center access to Management, Staging, or Production.
- Staging operations must be performed through an approved operational role.
- Any future exception must be justified and documented.

### Review Trigger

Review this decision if a controlled developer-testing requirement emerges in Staging.

---

## ADR-011: Limit DevOps Access to Non-Production

**Status:** Accepted

### Context

DevOps responsibilities will eventually include infrastructure automation and deployments.

However, no approved Production deployment or temporary-elevation workflow currently exists.

### Decision

Assign the DevOps group to Development and Staging only.

Do not provide a direct standing IAM Identity Center assignment to Production.

### Rationale

This supports non-production operations without introducing premature Production access.

### Consequences

- DevOps access is limited to the documented non-production scope.
- Production deployment authority remains unimplemented.
- Future Production access requires a separate approval and control model.

### Review Trigger

Review this decision when the Production environment, deployment pipeline, or approved Production operating model is introduced.

---

## ADR-012: Keep Production Without Direct Standing IAM Identity Center Assignments

**Status:** Accepted

### Context

The current project does not include:

- a Production workload;
- an approval workflow;
- temporary Production elevation;
- a break-glass access process;
- tested Production operating procedures.

### Decision

Leave Production without direct standing IAM Identity Center user or group assignments.

### Approved Statement

> Production has no direct standing IAM Identity Center assignments.

### Scope Limitation

This statement applies only to direct IAM Identity Center assignments.

It does not prove that every possible Management-to-Production, root, service-role, or cross-account access path has been removed.

### Rationale

An empty Production assignment configuration provides a defensible deny-by-default position within the documented IAM Identity Center access model.

### Consequences

- Broader Production isolation must not yet be claimed.
- Management-to-Production role paths require separate review.
- Future Production access must be approved, temporary, auditable, and revocable.
- Production elevation remains outside the current implementation.

### Review Trigger

Review this decision before any Production workload is deployed or Production administration is required.

---

## ADR-013: Review the Default Organization Account Access Role Separately

**Status:** Planned

### Context

AWS Organizations may create `OrganizationAccountAccessRole` in member accounts.

Depending on its trust relationship and Management-account permissions, this role can provide a Management-to-member-account administrative path.

### Decision

Review the trust relationship, authorized principals, and permissions associated with the organization access role before making a broader Production-isolation claim.

### Rationale

The absence of direct IAM Identity Center assignments does not eliminate every possible cross-account administrative route.

### Consequences

Until the review is completed, the documentation will use the narrower statement:

> Production has no direct standing IAM Identity Center assignments.

The documentation will not state:

> Nobody can access Production.

### Review Trigger

Complete this review before describing the Production boundary as fully controlled or airtight.

---

# Scope Closure

## ADR-014: End the Current IAM Implementation After Part 4

**Status:** Accepted

### Context

The AWS Organization, IAM Identity Center groups, permission sets, and account assignments have been implemented.

The test-user, MFA-registration, and workforce access-portal activities described in Part 5 will not be completed as part of the present milestone.

### Decision

Close the current IAM implementation after Part 4.

Part 5 is excluded from the current implementation scope rather than represented as incomplete work.

### Rationale

The implemented architecture already establishes:

- separate AWS account boundaries;
- centralized workforce identity;
- role-based groups;
- permission-set baselines;
- account-specific assignments;
- no direct standing Production IAM Identity Center assignment.

The repository should document only the controls that were actually implemented and intentionally included in scope.

### Consequences

- No test-user or access-portal validation claim will be made.
- No Part 5 screenshots will be published.
- MFA validation will not be represented as completed.
- The current IAM documentation closes at the administrator-side account-assignment boundary.
- Future user validation may be introduced as a separate enhancement.

### Review Trigger

Review this decision only if representative workforce-user testing is added later.

---

# Documentation Decisions

## ADR-015: Use GitHub as a Documentation Repository

**Status:** Accepted

### Context

The AWS Organization and IAM foundation were implemented directly in AWS.

A structured location is still required for architecture documentation, decisions, diagrams, and sanitized console evidence.

### Decision

Use GitHub to organize and publish:

- the implementation overview;
- AWS Organization documentation;
- IAM architecture documentation;
- architectural decisions;
- architecture diagrams;
- sanitized AWS console screenshots;
- implementation status and scope limitations.

GitHub will not be described as the platform where the IAM infrastructure was built.

### Rationale

This maintains a clear distinction:

- AWS is the implementation platform;
- GitHub is the documentation and portfolio platform.

### Consequences

- AWS configuration remains the source of implementation truth.
- GitHub documentation must accurately reflect the AWS environment.
- Documentation must be revised when the AWS implementation changes.
- Sensitive AWS information must be removed before evidence is published.

### Review Trigger

Review this decision when infrastructure as code is introduced and GitHub begins storing Terraform, policies, workflows, or deployable configuration.

---

## ADR-016: Separate Decisions from Implementation Evidence

**Status:** Accepted

### Context

Repeating screenshots across several documents creates unnecessary duplication and increases maintenance effort.

### Decision

Use the following documentation responsibilities:

| Location | Purpose |
|---|---|
| `README.md` | Project overview, status, scope, and navigation |
| `decisions.md` | Architecture and security reasoning |
| `aws-organisation/` | AWS Organizations implementation documentation |
| `iam-architecture/` | IAM design and account-assignment documentation |
| `screenshots/` | Sanitized AWS console evidence |

The decisions document will not contain repeated screenshots.

### Rationale

Each part of the repository should have one clear responsibility.

This keeps the decision record readable while preserving evidence in dedicated documentation and screenshot locations.

### Consequences

- Decisions remain focused on context, rationale, consequences, and review triggers.
- Evidence is referenced from the relevant implementation documentation.
- Screenshot changes do not require rewriting the decision record unless the underlying decision changes.

### Review Trigger

Review this structure when VPC, Terraform, CI/CD, security monitoring, or additional Month 1 documentation is introduced.

---

# Decision Summary

| Decision | Status |
|---|---|
| Multi-account AWS Organization | Accepted |
| Management account reserved for governance | Accepted |
| IAM Identity Center for workforce access | Accepted |
| IAM Identity Center directory as the initial identity source | Accepted |
| Role-based workforce groups | Accepted |
| Permission sets defined before account assignments | Accepted |
| Conservative visibility-focused permission baselines | Accepted |
| Governance permissions restricted to Management | Accepted |
| Account-specific workforce assignments | Accepted |
| Developers limited to Development | Accepted |
| DevOps limited to Development and Staging | Accepted |
| No direct standing Production IAM Identity Center assignments | Accepted |
| Organization account access-role review | Planned |
| Current IAM implementation closed after Part 4 | Accepted |
| GitHub used for documentation and evidence | Accepted |
| Decisions separated from screenshots and implementation evidence | Accepted |

---

# Future Review Events

This decision record should be reviewed when:

- the VPC foundation is implemented;
- application workloads are introduced;
- Terraform is adopted;
- CI/CD pipelines are created;
- Developer or DevOps write permissions are required;
- Production workloads are deployed;
- Production access or elevation is introduced;
- service control policies are implemented;
- centralized logging or security monitoring is added;
- an external identity provider is connected;
- representative workforce-user validation is introduced;
- AWS managed permission policies change.
