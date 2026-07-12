# VinceOps Cloud Network and Web Deployment Architecture

## Overview

This document describes the AWS network and web deployment architecture implemented during Month 2 of VinceOps Cloud.

The project established a complete deployment path from a custom Amazon VPC to a public HTTPS website hosted on Amazon EC2 and served through Nginx.

The implementation covered:

- custom VPC networking;
- public subnet configuration;
- internet routing;
- EC2 compute deployment;
- SSH administration;
- DNS mapping;
- Nginx installation;
- website deployment;
- HTTPS certificate configuration;
- network logging;
- functional validation;
- first-pass external security testing.

The infrastructure was implemented directly in AWS. GitHub contains the architecture documentation and sanitized point-in-time evidence.

---

## Architecture Summary

```text
User Browser
      │
      ▼
vinceops.site
DNS A Record
      │
      ▼
EC2 Public Address
      │
      ▼
Internet Gateway
      │
      ▼
Public Route Table
0.0.0.0/0 → Internet Gateway
      │
      ▼
Public Subnet
      │
      ▼
Security Group
      │
      ▼
Amazon EC2
Ubuntu Server
      │
      ▼
Nginx
/var/www/html
      │
      ▼
VinceOps Website
HTTPS Enabled
```

Supporting network evidence path:

```text
VPC Network Activity
        │
        ▼
VPC Flow Logs
        │
        ▼
Private Amazon S3 Destination
```

TLS path:

```text
vinceops.site
www.vinceops.site
        │
        ▼
Certbot
        │
        ▼
Let's Encrypt
        │
        ▼
Nginx HTTPS Configuration
```

---

# Part 1: VPC and Network Foundation

## Objective

Create a dedicated AWS network boundary before launching the web server.

## Implementation

A custom VPC was used rather than relying on the default AWS VPC.

The network foundation included:

- a custom VPC;
- a public subnet;
- an Internet Gateway;
- a public route table;
- subnet-to-route-table association;
- security controls;
- VPC Flow Logs;
- an Amazon S3 log destination.

## Public Subnet

The public subnet was created inside the VinceOps VPC using the following IPv4 CIDR range:

```text
10.0.1.0/24
```

The subnet was selected as the location for the internet-facing EC2 instance.

### Evidence

[View public subnet evidence](./screenshots/01-public-subnet-created.png)

![Public subnet created](./screenshots/01-public-subnet-created.png)

## Route-Table Association

The public subnet was explicitly associated with the VinceOps route table.

This ensures that the subnet uses the intended routing configuration rather than relying on an unreviewed default association.

### Evidence

[View route-table association evidence](./screenshots/02-route-table-subnet-association.png)

![Route-table subnet association](./screenshots/02-route-table-subnet-association.png)

## Internet Gateway Route

The route table contains an active default IPv4 route:

```text
0.0.0.0/0 → Internet Gateway
```

This provides the public subnet with an internet route.

### Evidence

[View Internet Gateway route evidence](./screenshots/03-public-route-to-internet-gateway.png)

![Internet Gateway route](./screenshots/03-public-route-to-internet-gateway.png)

## VPC Flow Logs

VPC Flow Logs were enabled to capture network traffic metadata for troubleshooting and security review.

The Flow Log configuration records all supported traffic types and sends the resulting log data to the designated Amazon S3 destination.

### Evidence

[View VPC Flow Log evidence](./screenshots/04-vpc-flow-logs-active.png)

![VPC Flow Logs active](./screenshots/04-vpc-flow-logs-active.png)

---

# Part 2: EC2 Compute Deployment

## Objective

Launch the compute layer that hosts the Nginx web server and deployed website.

## Implementation

An Ubuntu-based Amazon EC2 instance was launched inside the custom network.

The instance was attached to:

- the VinceOps VPC;
- the public subnet;
- the project security controls;
- a public network interface;
- an SSH key pair;
- a 20 GB root volume.

## Instance Baseline

| Setting | Implementation |
|---|---|
| Cloud service | Amazon EC2 |
| Operating system | Ubuntu Linux |
| Instance type | `t2.medium` |
| Storage | 20 GB |
| Network | Custom VinceOps VPC |
| Subnet | Public subnet |
| Public access | Enabled for the project deployment |
| Administration | SSH key-pair authentication |
| Metadata protection | IMDSv2 |

The instance was used as the application compute and web-serving layer.

### Evidence

[View EC2 instance evidence](./screenshots/05-ec2-instance-summary.png)

![EC2 instance summary](./screenshots/05-ec2-instance-summary.png)

---

# Part 3: Secure Server Administration

## Objective

Connect to the EC2 instance and perform the server configuration required for web deployment.

## SSH Access

Key-based SSH authentication was used to access the Ubuntu instance.

This avoided password-based server authentication.

### Evidence

[View SSH access evidence](./screenshots/06-ssh-access-success.png)

![SSH access success](./screenshots/06-ssh-access-success.png)

## Initial Server Preparation

The server package index was updated before installing the required services.

```bash
sudo apt update -y
sudo apt upgrade -y
```

Administrative access information, private key material, and local device details were removed from the public evidence.

---

# Part 4: Nginx Web Service

## Objective

Install and configure the web service that serves the VinceOps website.

## Installation

Nginx was installed on the Ubuntu EC2 instance.

```bash
sudo apt install nginx -y
```

The service was enabled and started:

```bash
sudo systemctl enable nginx
sudo systemctl start nginx
```

The service status was validated:

```bash
sudo systemctl status nginx
```

A local HTTP response was also tested:

```bash
curl -I http://localhost
```

## Web Root

The deployed website files were served from:

```text
/var/www/html
```

The default Nginx content was replaced with the customized VinceOps website files.

### Evidence

[View Nginx validation evidence](./screenshots/07-nginx-active-http-response.png)

![Nginx active and responding](./screenshots/07-nginx-active-http-response.png)

---

# Part 5: DNS Mapping

## Objective

Connect the human-readable project domain to the public web server.

## Implementation

A DNS A record was configured for:

```text
vinceops.site
```

The record pointed the domain to the public address of the EC2 web server.

## DNS Validation

DNS propagation was checked across multiple global DNS resolvers before certificate issuance.

This confirmed that the domain resolved publicly to the deployed service.

### Evidence

[View DNS propagation evidence](./screenshots/08-dns-propagation-vinceops-site.png)

![DNS propagation for vinceops.site](./screenshots/08-dns-propagation-vinceops-site.png)

## DNS Architecture Decision

Direct DNS-to-EC2 mapping was used to keep the practical deployment simple and transparent.

Because a standard EC2 public address may change after the instance is stopped and restarted, this architecture represents a point-in-time lab deployment.

A longer-running environment could use an Elastic IP, Application Load Balancer, or another stable entry point.

---

# Part 6: TLS Tooling

## Objective

Install the tooling required to request and deploy a trusted HTTPS certificate.

## Certbot Installation

Certbot and the Nginx integration were installed on the server.

```bash
sudo apt install certbot -y
sudo apt install python3-certbot-nginx -y
```

The Nginx configuration was checked before certificate issuance:

```bash
sudo nginx -t
```

### Evidence

[View Certbot installation evidence](./screenshots/09-certbot-installed.png)

![Certbot installed](./screenshots/09-certbot-installed.png)

---

# Part 7: HTTPS Certificate Deployment

## Objective

Secure the public website using a trusted TLS certificate.

## Initial Certificate Issuance

A Let's Encrypt certificate was requested through Certbot and deployed through the Nginx integration.

```bash
sudo certbot --nginx -d vinceops.site
```

### Evidence

[View certificate issuance evidence](./screenshots/10-certbot-certificate-issued.png)

![Certificate issued](./screenshots/10-certbot-certificate-issued.png)

## Hostname Coverage Correction

The initial certificate covered the root domain:

```text
vinceops.site
```

The configuration was subsequently expanded to cover both public hostnames:

```text
vinceops.site
www.vinceops.site
```

This ensured that users could securely access either hostname without a certificate-name mismatch.

### Evidence

[View root and www certificate evidence](./screenshots/11-certificate-expanded-root-and-www.png)

![Certificate expanded for root and www](./screenshots/11-certificate-expanded-root-and-www.png)

## Certificate Validation

Browser certificate inspection confirmed that the certificate was issued by Let's Encrypt and applied to the VinceOps domain.

### Evidence

[View certificate-detail evidence](./screenshots/12-https-certificate-details.png)

![HTTPS certificate details](./screenshots/12-https-certificate-details.png)

---

# Part 8: Website Deployment and Validation

## Objective

Confirm that the customized application was successfully served through the public HTTPS endpoint.

## Deployment Result

The customized VinceOps website was served through:

```text
https://vinceops.site
```

The deployment path successfully combined:

- DNS resolution;
- public AWS routing;
- EC2 compute;
- Nginx web serving;
- TLS encryption;
- customized website content.

### Evidence

[View deployed website evidence](./screenshots/13-vinceops-site-https-deployed.png)

![VinceOps website deployed through HTTPS](./screenshots/13-vinceops-site-https-deployed.png)

## Functional Validation

Validation included:

- successful domain resolution;
- successful HTTPS loading;
- correct certificate presentation;
- homepage availability;
- static content loading;
- Nginx service response;
- server access and error-log review.

Useful validation commands included:

```bash
curl -I https://vinceops.site

sudo tail -n 50 /var/log/nginx/access.log
sudo tail -n 50 /var/log/nginx/error.log

df -h
free -m
```

---

# Part 9: External Security Validation

## Objective

Review the public exposure of the self-owned website using an authorised external scan.

## Initial Result

A light scan of the top 100 ports initially observed:

| Port | Service | State |
|---:|---|---|
| 80 | HTTP | Open |
| 443 | HTTPS | Open |

### Evidence

[View initial scan screenshot](./screenshots/14-port-scan-before-http-and-https.png)

![Initial external port scan](./screenshots/14-port-scan-before-http-and-https.png)

[View initial scan report](./security-reports/port-scan-before-http-and-https.pdf)

## Follow-Up Result

After reviewing the public exposure, a follow-up light scan observed:

| Port | Service | State |
|---:|---|---|
| 443 | HTTPS | Open |

[View follow-up scan report](./security-reports/port-scan-after-https-only.pdf)

## Interpretation

The result demonstrates a reduction in the publicly observed service exposure from HTTP and HTTPS to HTTPS only within the limited scan scope.

The scan covered the top 100 ports and should not be interpreted as a full manual penetration test or proof that all possible vulnerabilities were eliminated.

Detailed security notes are available in:

[Security Testing Notes](./security-testing.md)

---

# Implementation Decisions

The principal architectural decisions were:

1. Build the custom VPC before launching compute.
2. Place the public web server in a dedicated public subnet.
3. Explicitly associate the subnet with the intended route table.
4. Use an Internet Gateway for the public traffic path.
5. Record network traffic metadata through VPC Flow Logs.
6. Host the application on an Ubuntu EC2 instance.
7. Use key-based SSH authentication for server administration.
8. Serve the website through Nginx.
9. Map the project domain directly to the EC2 service.
10. Enable HTTPS using Certbot and Let's Encrypt.
11. Validate both root and `www` certificate coverage.
12. Perform functional and external security validation before archiving the deployment.

Detailed reasoning is documented in:

[Architecture and Technical Decisions](./decisions.md)

---

# Deployment Lifecycle

The EC2-hosted website was successfully deployed and validated through:

- DNS resolution;
- Nginx service testing;
- HTTPS certificate inspection;
- website functionality checks;
- external port scanning.

After the evidence had been collected, the EC2 instance was stopped to control ongoing laboratory costs.

The repository therefore documents a completed point-in-time deployment rather than a continuously operated production service.

---

# Related Documentation

| Document | Purpose |
|---|---|
| [Month 2 Overview](./README.md) | Recruiter-facing project summary |
| [Technical Decisions](./decisions.md) | Architecture decisions and trade-offs |
| [Security Testing](./security-testing.md) | Security scan results and remediation notes |
| [Serverless Bonus](./serverless-bonus.md) | Additional serverless hosting exercise |
| [Evidence Register](./screenshots/README.md) | Sanitized implementation screenshots |

---

## Outcome

The Month 2 implementation established a complete public deployment path from AWS networking to an HTTPS-enabled website.

The resulting architecture demonstrated:

- custom AWS network design;
- internet routing;
- public compute deployment;
- secure server access;
- DNS configuration;
- Nginx web hosting;
- trusted TLS encryption;
- network logging;
- functional application validation;
- evidence-led security review.

---

### Navigation

[Back to Month 2 Overview](./README.md) ·
[Technical Decisions](./decisions.md) ·
[Security Testing](./security-testing.md) ·
[Evidence](./screenshots/README.md)
