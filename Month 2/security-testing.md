# Month 2 Security Testing and Exposure Review

![Security](https://img.shields.io/badge/Security-External%20Exposure%20Review-0969DA)
![Scope](https://img.shields.io/badge/Scope-Top%20100%20Ports-FF9900)
![Result](https://img.shields.io/badge/Follow--Up-HTTPS%20Only-2EA44F)
![Authorisation](https://img.shields.io/badge/Testing-Authorised-2EA44F)

## Overview

This document records the security-testing activities performed during the VinceOps Cloud Month 2 AWS network and secure web-deployment project.

The security review was performed against the project owner’s domain:

```text
vinceops.site
```

The purpose of the test was to examine which network services were publicly observable after the EC2, Nginx, DNS, and HTTPS deployment had been completed.

The testing process included:

- confirming that the website was reachable through HTTPS;
- reviewing the externally observed ports;
- comparing the initial and follow-up scan results;
- reducing unnecessary publicly observed service exposure;
- documenting the testing limitations;
- preserving sanitized scan evidence.

---

## Security-Testing Objective

The main objective was to answer the following question:

> Which services could an external scanner observe on the public VinceOps website after deployment?

Creating AWS resources successfully does not automatically prove that the resulting public exposure is appropriate.

The website therefore required validation from outside the AWS environment.

The security review focused on:

- public port exposure;
- HTTP and HTTPS availability;
- encrypted web access;
- before-and-after scan comparison;
- evidence-led remediation validation.

---

## Authorisation and Scope

The external scan was performed only against infrastructure owned and controlled by the project owner.

### Authorised Target

```text
vinceops.site
```

### Testing Method

A light external port scanner was used to assess the most commonly used network ports.

### Scan Scope

```text
Top 100 TCP ports
```

### Purpose

The scan was used as:

> A first-pass external service-exposure assessment.

It was not represented as:

- a complete penetration test;
- a full vulnerability assessment;
- an application-security code review;
- a complete scan of all 65,535 TCP ports;
- a UDP-port assessment;
- proof that the website contained no vulnerabilities;
- proof that every unreported port was closed.

---

# 1. Pre-Scan Validation

Before the external scan was performed, the deployment was validated through the following checks:

- the domain resolved publicly;
- the Nginx service was active;
- the customized website loaded successfully;
- the website responded through HTTPS;
- the Let’s Encrypt certificate was active;
- the certificate covered the intended hostnames;
- server access was functioning;
- the public endpoint could be reached externally.

The configured hostnames included:

```text
vinceops.site
www.vinceops.site
```

Useful functional checks included:

```bash
sudo systemctl status nginx
curl -I http://localhost
curl -I https://vinceops.site
```

Nginx logs were also available for operational review:

```bash
sudo tail -n 50 /var/log/nginx/access.log
sudo tail -n 50 /var/log/nginx/error.log
```

---

# 2. Initial External Scan

## Initial Observation

The first authorised external scan observed two publicly accessible services:

| Port | Protocol | Common Service | Observed State |
|---:|---|---|---|
| 80 | TCP | HTTP | Open |
| 443 | TCP | HTTPS | Open |

## Interpretation

The result showed that the web server was externally reachable through both:

```text
HTTP  → Port 80
HTTPS → Port 443
```

The HTTPS service was required for the encrypted website.

The HTTP service was reviewed because the completed deployment objective was to provide secure access through HTTPS.

## Evidence

[View the initial scan screenshot](./%20screenshots/14-port-scan-before-http-and-https.png)

![Initial scan showing HTTP and HTTPS](./%20screenshots/14-port-scan-before-http-and-https.png)

[View the initial detailed scan report](./%20screenshots/%20security-reports/port-scan-before-http-and-https.png)

---

# 3. Exposure Review

After receiving the initial result, the public service exposure was reviewed.

The review focused on whether both publicly observed ports were necessary for the completed point-in-time deployment.

## Initial Exposure

```text
Port 80  → HTTP
Port 443 → HTTPS
```

## Intended Completed Access

```text
Port 443 → HTTPS
```

The deployment had already received a valid Let’s Encrypt certificate, and the website was accessible using:

```text
https://vinceops.site
```

The public configuration was therefore adjusted so that the follow-up scan no longer observed the HTTP service.

## Important Evidence Boundary

A final post-adjustment AWS security-group screenshot was not retained.

For that reason, this repository does not claim that the follow-up scan independently proves the exact AWS rule that caused the result.

The evidence supports only the externally observed change:

```text
Before:
80 and 443 observed as open

After:
443 observed as open
```

This distinction keeps the documentation evidence-based.

---

# 4. Follow-Up External Scan

## Follow-Up Observation

A second authorised light scan was performed after the public exposure had been reviewed.

The follow-up scan observed:

| Port | Protocol | Common Service | Observed State |
|---:|---|---|---|
| 443 | TCP | HTTPS | Open |

Port 80 was not reported as open within the follow-up scan result.

## Before-and-After Comparison

| Stage | Port 80 | Port 443 |
|---|---|---|
| Initial scan | Open | Open |
| Follow-up scan | Not observed as open | Open |

## Interpretation

Within the scope of the selected top-100-port scan, the externally observed exposure was reduced from two web ports to one encrypted web port.

```text
Initial:
HTTP  + HTTPS

Follow-up:
HTTPS only
```

This demonstrated a review-and-validation process rather than stopping after the first successful website deployment.

## Evidence

[View the follow-up scan report](./%20screenshots/%20security-reports/port-scan-after-https-only.png)

![Follow-up scan showing HTTPS](./%20screenshots/%20security-reports/port-scan-after-https-only.png)

---

# 5. Security Finding

## Finding SEC-01: HTTP and HTTPS Were Initially Publicly Observable

### Severity

```text
Informational / Configuration Review
```

### Initial Condition

The external scanner observed:

- TCP port 80;
- TCP port 443.

### Security Consideration

Port 80 provides unencrypted HTTP communication unless the server immediately redirects the request to HTTPS.

Even when HTTP exists only to redirect users, the configuration should be intentional and documented.

### Action Taken

The publicly exposed services were reviewed and adjusted.

### Validation

The follow-up scan observed only TCP port 443 within its top-100-port scope.

### Status

```text
Reviewed and externally revalidated
```

### Evidence Limitation

The available evidence demonstrates the scanner’s observed result.

It does not independently confirm:

- the exact final security-group rule;
- every host firewall rule;
- every possible network path;
- all TCP ports;
- any UDP ports;
- the absence of application vulnerabilities.

---

# 6. HTTPS Validation

The website used a Let’s Encrypt certificate deployed through Certbot and Nginx.

The certificate configuration was expanded to cover:

```text
vinceops.site
www.vinceops.site
```

This resolved the initial hostname-coverage limitation.

## HTTPS Checks

The following areas were reviewed:

- certificate issuance;
- certificate deployment through Nginx;
- root-domain coverage;
- `www` hostname coverage;
- successful secure browser connection;
- encrypted website loading;
- certificate details in the browser.

## Supporting Evidence

- [Certbot installation](./%20screenshots/9-certbot-installed.png)
- [Initial certificate issuance](./%20screenshots/10-certbot-certificate-issued.png)
- [Root and www certificate coverage](./%20screenshots/11-certificate-expanded-root-and-www.png)
- [Browser certificate details](./%20screenshots/12-https-certificate-detail.png)
- [HTTPS website deployment](./%20screenshots/13-vinceops-site-https-deployed.png)

---

# 7. Testing Limitations

The scan results must be interpreted within their documented scope.

## Port Coverage

The scanner assessed the top 100 commonly used ports.

It did not represent a scan of every possible TCP port.

## Protocol Coverage

The available reports document TCP-port scanning.

They do not provide evidence of a complete UDP assessment.

## Application Testing

The test did not demonstrate:

- SQL-injection testing;
- cross-site scripting testing;
- authentication testing;
- session-management testing;
- source-code review;
- API-security testing;
- business-logic testing;
- dependency scanning;
- authenticated application scanning.

## Infrastructure Testing

The scan did not independently validate:

- every security-group rule;
- every Network ACL rule;
- operating-system firewall rules;
- S3 bucket permissions;
- IAM policies;
- operating-system patch status;
- malware detection;
- file-integrity monitoring;
- intrusion detection;
- backup recoverability.

## Time Boundary

The scan reports represent the externally observed condition at the time each scan was performed.

Infrastructure configuration can change after testing.

---

# 8. Why This Was Not Described as a Full Penetration Test

A complete penetration test normally includes broader activities such as:

- target and scope definition;
- detailed reconnaissance;
- wider port and service enumeration;
- vulnerability discovery;
- controlled exploitation;
- privilege-escalation testing;
- application-security testing;
- impact analysis;
- remediation recommendations;
- retesting;
- formal reporting.

The Month 2 exercise used a light external scanner covering the top 100 ports.

The accurate description is therefore:

> Authorised external port scan and first-pass service-exposure assessment.

Using this wording avoids exaggerating the testing scope.

---

# 9. Security Controls Demonstrated

The Month 2 project demonstrated the following security-related controls and practices:

## Network Segmentation

The EC2 workload was deployed inside a custom Amazon VPC and public subnet.

## Controlled Routing

The subnet used an explicitly associated route table with an Internet Gateway route.

## Security-Group Use

AWS security-group controls were attached to the EC2 deployment.

## SSH Key Authentication

The Ubuntu server used key-based SSH authentication rather than password-based access.

## HTTPS Encryption

The public website used a trusted Let’s Encrypt certificate.

## Hostname Validation

Certificate coverage was corrected to include both the root and `www` hostnames.

## Network Visibility

VPC Flow Logs were enabled with an Amazon S3 destination.

## Application Logging

Nginx provided access and error logs.

## External Validation

The public endpoint was assessed from outside the AWS environment.

## Retesting

A second scan was performed after the exposure had been reviewed.

## Evidence Sanitization

Sensitive infrastructure, personal, and authentication information was removed from the public screenshots.

## Cost Management

The EC2 instance was stopped after validation and evidence collection had been completed.

---

# 10. HTTP and Certificate-Renewal Consideration

The follow-up scan observed only HTTPS port 443.

For a continuously operated environment, the relationship between HTTP access and certificate renewal would require a deliberate design.

Some Let’s Encrypt validation workflows may require HTTP availability during domain validation.

A longer-running implementation could use one of the following approaches:

### Option 1: Controlled HTTP-to-HTTPS Redirection

Keep port 80 available only to redirect requests to HTTPS and support the required certificate-validation workflow.

```text
HTTP request
     │
     ▼
301 redirect
     │
     ▼
HTTPS website
```

### Option 2: DNS-Based Certificate Validation

Use a DNS validation process that does not require the website to remain publicly reachable through HTTP.

### Option 3: Managed Load Balancer and Certificate Service

Use:

- an Application Load Balancer;
- AWS Certificate Manager;
- managed HTTPS termination.

### Option 4: Managed Hosting Platform

Use a managed hosting service that handles certificate creation and renewal automatically.

Because the EC2 workload was stopped after project validation, this repository does not claim that automatic certificate renewal remained continuously operational.

---

# 11. Recommended Future Security Improvements

A longer-running version of the deployment should consider:

## Network and Access

- limit SSH to a trusted administrative address;
- consider AWS Systems Manager instead of public SSH;
- place application servers in private subnets;
- use a managed load balancer;
- review both security groups and Network ACLs;
- document final inbound and outbound rules.

## HTTPS

- define a deliberate HTTP-to-HTTPS strategy;
- automate certificate-renewal monitoring;
- test certificate expiration alerts;
- consider AWS Certificate Manager;
- validate modern TLS configuration.

## Web Security

- add security headers;
- review the Content Security Policy;
- configure `X-Content-Type-Options`;
- configure clickjacking protection;
- configure Referrer Policy;
- remove unnecessary server-version disclosure;
- perform broader authorised web-application testing.

## Monitoring

- configure Amazon CloudWatch metrics and alarms;
- monitor CPU, memory, disk usage, and availability;
- centralise Nginx logs;
- analyse VPC Flow Logs;
- alert on unusual connection patterns;
- configure uptime monitoring.

## Server Hardening

- apply operating-system security updates;
- disable unnecessary services;
- review file and directory permissions;
- configure host firewall rules;
- implement automated patching;
- conduct dependency and malware scanning.

## Data Protection

- verify S3 Block Public Access;
- review S3 bucket policies;
- enable appropriate encryption;
- define log-retention and lifecycle policies;
- test backup and restoration procedures.

## Testing

- scan a broader authorised port range;
- perform authenticated vulnerability scanning;
- test web security headers;
- conduct application-layer assessment;
- document remediation and retesting;
- schedule periodic security reviews.

---

# 12. Evidence Sanitization

The public security-testing evidence was reviewed to remove or conceal:

- AWS account IDs;
- AWS resource IDs;
- EC2 public and private addresses;
- AWS public hostnames;
- administrator public addresses;
- local usernames;
- SSH key filenames;
- local file paths;
- Certbot registration email;
- certificate fingerprints;
- unrelated browser details;
- authentication information.

The following information was retained because it supports the project findings:

- `vinceops.site`;
- observed port numbers;
- scan status;
- service names;
- scan scope;
- before-and-after findings;
- certificate issuer;
- HTTPS deployment result.

---

# 13. Testing Outcome

The security-testing process demonstrated a complete review cycle:

```text
Deploy
   │
   ▼
Validate Website
   │
   ▼
Perform Initial External Scan
   │
   ▼
Review Public Exposure
   │
   ▼
Adjust Configuration
   │
   ▼
Perform Follow-Up Scan
   │
   ▼
Document Results and Limitations
```

## Final Observed Result

Within the limited top-100-port scan:

```text
HTTPS port 443 was observed as open.
```

The testing added an external validation layer to the AWS deployment and demonstrated that the project included review, adjustment, and retesting rather than only resource creation.

---

# Security Evidence

| Evidence | Link |
|---|---|
| Initial scan screenshot | [View evidence](./%20screenshots/14-port-scan-before-http-and-https.png) |
| Initial detailed report | [View report](./%20screenshots/%20security-reports/port-scan-before-http-and-https.png) |
| Follow-up report | [View report](./%20screenshots/%20security-reports/port-scan-after-https-only.png) |
| HTTPS certificate issuance | [View evidence](./%20screenshots/10-certbot-certificate-issued.png) |
| Root and `www` coverage | [View evidence](./%20screenshots/11-certificate-expanded-root-and-www.png) |
| Certificate details | [View evidence](./%20screenshots/12-https-certificate-detail.png) |
| HTTPS deployment | [View evidence](./%20screenshots/13-vinceops-site-https-deployed.png) |
| Complete evidence register | [View evidence register](./%20screenshots/README.md) |

---

# Related Documentation

| Document | Purpose |
|---|---|
| [Month 2 Overview](./README.md) | Main recruiter-facing project summary |
| [Network and Web Architecture](./network-web-architecture.md) | Detailed deployment architecture |
| [Architecture Decisions](./decisions.md) | Decisions, trade-offs, and limitations |
| [Serverless Bonus](./serverless-bonus.md) | Separate additional hosting exercise |
| [Evidence Register](./%20screenshots/README.md) | Sanitized implementation screenshots |

---

## Navigation

[Back to Month 2 Overview](./README.md) ·
[Architecture](./network-web-architecture.md) ·
[Decisions](./decisions.md) ·
[Serverless Bonus](./serverless-bonus.md) ·
[Evidence](./%20screenshots/README.md)
