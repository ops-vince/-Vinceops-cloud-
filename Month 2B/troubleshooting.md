# VinceOps Month 2B — Troubleshooting Record

Month 2B was built iteratively rather than through a perfect first-pass deployment.

Several failures appeared across compute automation, IAM, shared storage, monitoring and alerting. Each incident was investigated at the affected layer, corrected, and revalidated before the infrastructure was considered stable.

This record preserves the most important troubleshooting cases from the VinceOps Month 2B infrastructure evolution.

---

## Incident 1 — Auto Scaling Instance Became Unhealthy

### Symptom

One of the EC2 instances launched by the Auto Scaling Group failed to become a healthy application target.

The instance existed, but the load-balancing layer could not reliably treat it as a functioning web node.

### Investigation

The troubleshooting path included checking:

* EC2 instance state,
* target-group health,
* Launch Template configuration,
* User Data execution,
* Nginx availability,
* EFS mounting,
* and application health-check response.

The issue was traced back to the server bootstrap process rather than the Application Load Balancer itself.

### Root Cause

The web-server configuration being launched from the existing Launch Template was not completing reliably.

This meant the instance could be running at the EC2 layer while still failing application-level health validation.

### Resolution

The Launch Template was updated with a corrected bootstrap configuration.

A new template version was introduced rather than overwriting the existing configuration blindly.

The Auto Scaling Group was then allowed to launch replacement compute using the corrected version.

### Verification

The replacement application targets eventually reported healthy through the target group.

The validated state showed:

```text
2 Total Targets
2 Healthy
0 Unhealthy
```

### Engineering Lesson

An EC2 instance being in the `running` state does not prove that the application is healthy.

Infrastructure health must be validated at the application layer.

Launch Template versioning also provides a safer way to introduce bootstrap changes while retaining a known previous state.

---

## Incident 2 — Amazon Linux 2023 Package Conflict Broke Bootstrap

### Symptom

A newly launched web server failed during package installation.

The User Data script attempted to install the dependencies required for Nginx and EFS, but the bootstrap process did not complete successfully.

### Investigation

The instance bootstrap log was reviewed rather than assuming the problem was related to networking or Auto Scaling.

The package installation stage revealed a conflict involving:

```text
curl
```

and the package already present on Amazon Linux 2023:

```text
curl-minimal
```

### Root Cause

Amazon Linux 2023 already included `curl-minimal`.

The bootstrap script attempted to install the full `curl` package alongside it, creating a package conflict.

The original package command included:

```text
dnf install -y nginx amazon-efs-utils curl
```

### Resolution

The unnecessary full `curl` installation was removed.

The corrected dependency installation became:

```bash
dnf install -y nginx amazon-efs-utils
```

The existing `curl-minimal` capability was sufficient for the bootstrap requirements.

### Verification

A new Launch Template version was created with the corrected User Data.

Replacement instances were able to progress beyond the package-installation stage and complete the remaining bootstrap operations.

### Engineering Lesson

Bootstrap scripts must account for the base operating system rather than assuming package behaviour is identical across Linux distributions or versions.

User Data should be treated as production code:

```text
Write
  ↓
Launch
  ↓
Inspect logs
  ↓
Correct
  ↓
Version
  ↓
Retest
```

---

## Incident 3 — EC2 Could Not Retrieve the Datadog Secret

### Symptom

The private web server could not retrieve the Datadog API key from AWS Systems Manager Parameter Store.

Initial credential checks failed.

### Investigation

The investigation separated the problem into two questions:

1. Did the EC2 instance have usable AWS credentials?
2. If credentials existed, did the role have permission to access the parameter?

A basic identity test was used:

```bash
aws sts get-caller-identity >/dev/null 2>&1 \
  && echo "IAM credentials OK" \
  || echo "IAM credentials FAILED"
```

The instance did not initially have the expected usable EC2 role credentials.

### Root Cause

The expected IAM configuration had not been correctly attached to the EC2 workload.

The application server therefore could not authenticate to AWS services through an instance role.

### Resolution

The correct EC2 IAM role was attached:

```text
vinceops-m2b-web-ec2-role
```

The role was given controlled permission to retrieve the required Systems Manager parameter.

The Datadog secret itself was stored as a `SecureString` under:

```text
/vinceops/m2b/datadog/api-key
```

### Verification

After the role correction:

```text
IAM credentials OK
SSM secret retrieval OK
```

were successfully validated.

### Engineering Lesson

IAM failures should be isolated before debugging the dependent application.

The correct sequence is:

```text
Can the instance authenticate to AWS?
            ↓
Does the IAM role permit the action?
            ↓
Does the resource exist?
            ↓
Can the application consume it?
```

This is more efficient than debugging the downstream monitoring agent first.

---

## Incident 4 — Datadog API Validation Returned HTTP Errors

### Symptom

Datadog integration did not initially validate successfully.

During troubleshooting, API calls returned HTTP errors including:

```text
400
```

and later:

```text
403
```

### Investigation

The investigation moved beyond the Datadog Agent itself and tested the credential independently.

The Datadog validation endpoint was used to determine whether the stored secret was actually accepted by the Datadog API.

This exposed two separate problems.

### Root Cause — Part 1

The stored value was initially malformed.

This resulted in request-format and header-related failures.

### Root Cause — Part 2

There was also confusion between two different Datadog credential types:

* Datadog API Key
* Datadog Application Key

The wrong credential type resulted in authorisation failure.

### Resolution

A fresh Datadog **API Key** was created.

The correct value was stored in Systems Manager Parameter Store as the encrypted parameter used by the EC2 bootstrap process.

The credential was then validated independently before relying on the Datadog Agent.

### Verification

The Datadog validation endpoint returned:

```json
{"valid":true}
```

The Datadog Agent subsequently connected and began reporting host telemetry.

### Engineering Lesson

When an integration fails, validate the dependency independently from the application consuming it.

The troubleshooting sequence became:

```text
Secret storage
     ↓
IAM retrieval
     ↓
Credential format
     ↓
External API validation
     ↓
Agent configuration
     ↓
Telemetry
```

This reduced the number of unknowns being investigated at the same time.

---

## Incident 5 — Datadog Monitor Had No Working Slack Recipient

### Symptom

The Datadog CPU monitor was configured, but the expected Slack notification path was not initially functioning correctly.

The monitor interface indicated that no valid notification recipient had been recognised.

### Investigation

The Datadog monitor configuration and Slack integration were reviewed separately.

The Slack channel reference had been typed into the monitor configuration, but simply entering text was not sufficient for Datadog to recognise the integration target.

The Datadog application also needed access to the Slack channel.

### Root Cause

The Slack notification recipient had not been selected as an actual recognised Datadog integration target.

Additionally, the Datadog Slack application needed to be available inside the intended operations channel.

### Resolution

The `#vinceops-alerts` channel was correctly connected.

The Datadog application was made available to the channel and the Slack recipient was selected through the Datadog recipient/autocomplete mechanism.

A test notification was then issued before relying on a real infrastructure condition.

### Verification

Slack successfully received the Datadog test notification.

The notification path was now:

```text
Datadog Monitor
      ↓
Slack Integration
      ↓
#vinceops-alerts
```

### Engineering Lesson

A configured integration should not be assumed to work simply because its name appears in a settings field.

The complete notification path must be tested independently before it is needed during a real alert.

---

## Incident 6 — Controlled CPU Alert and Recovery Validation

### Objective

After the monitoring and Slack integrations were working independently, the final requirement was to prove the entire operational path under an actual host condition.

### Test

CPU load was deliberately introduced on a VinceOps web server.

A controlled load command was used:

```bash
for i in $(seq 1 $(nproc)); do
    timeout 180s yes > /dev/null &
done
```

The workload was temporary and intentionally created for monitoring validation.

### Observation

CPU utilisation increased sufficiently to cross the configured Datadog monitor threshold.

The monitor transitioned into an alert condition.

### Verification

The complete sequence was successfully observed:

```text
Normal CPU
    ↓
Controlled CPU Load
    ↓
Threshold Exceeded
    ↓
Datadog Alert
    ↓
Slack Notification
```

The load was then stopped:

```bash
pkill -x yes
```

CPU utilisation returned toward normal.

Datadog detected the recovery condition and generated the corresponding Slack recovery notification.

### Final Result

The full monitoring workflow was proven:

```text
Host metric
    ↓
Monitor evaluation
    ↓
Alert state
    ↓
Operational notification
    ↓
Condition resolved
    ↓
Recovery state
    ↓
Recovery notification
```

Supporting evidence is available under:

[`evidence/07-observability/`](./evidence/07-observability/)

### Engineering Lesson

A dashboard showing a green status is not sufficient evidence that an alerting system works.

Operational monitoring should validate:

1. metric collection,
2. threshold evaluation,
3. alert transition,
4. notification delivery,
5. recovery detection,
6. and recovery notification.

---

# Troubleshooting Approach

Across these incidents, the most effective troubleshooting pattern was:

```text
Observe the symptom
        ↓
Identify the affected layer
        ↓
Inspect logs/state
        ↓
Reduce the problem
        ↓
Test the dependency independently
        ↓
Correct one variable
        ↓
Revalidate
        ↓
Capture evidence
```

This prevented unrelated AWS services from being changed merely because they were part of the same architecture.

---

# What Changed Because of These Incidents

The final Month 2B environment became stronger because of the failures encountered during implementation.

| Failure                        | Resulting Improvement                              |
| ------------------------------ | -------------------------------------------------- |
| Unhealthy application instance | Better Launch Template and health-check validation |
| Package conflict               | Operating-system-aware bootstrap automation        |
| Missing EC2 credentials        | Correct IAM role-based AWS access                  |
| SSM retrieval failure          | Explicit dependency and permission validation      |
| Invalid Datadog credential     | Independent API-key validation                     |
| API/Application Key confusion  | Clearer secret management                          |
| Slack recipient failure        | End-to-end notification testing                    |
| CPU alert test                 | Verified operational alert and recovery lifecycle  |

---

# Engineering Perspective

The objective of Month 2B was never to produce an infrastructure deployment that appeared perfect.

The more valuable result was establishing a repeatable engineering process for determining **why infrastructure was not behaving as intended**.

The strongest lessons came from distinguishing between layers:

```text
EC2 running
      ≠
Application healthy

Secret stored
      ≠
Instance authorised

Agent installed
      ≠
Telemetry reporting

Monitor configured
      ≠
Notification delivered

Alert received
      ≠
Recovery path validated
```

That distinction will carry forward into subsequent VinceOps infrastructure work.

---

## Related Documentation

[← Month 2B Overview](./README.md) ·
[Engineering Decisions](./decisions.md) ·
[Engineering Evidence](./evidence/README.md) ·
[Architecture](./architecture/)

