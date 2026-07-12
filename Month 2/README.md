# Month 2: AWS Network and Secure Web Deployment

![AWS](https://img.shields.io/badge/AWS-VPC%20%7C%20EC2-FF9900?logo=amazonaws&logoColor=white)
![Ubuntu](https://img.shields.io/badge/OS-Ubuntu-E95420?logo=ubuntu&logoColor=white)
![Nginx](https://img.shields.io/badge/Web%20Server-Nginx-009639?logo=nginx&logoColor=white)
![HTTPS](https://img.shields.io/badge/Security-HTTPS-2EA44F)
![Status](https://img.shields.io/badge/Status-Completed-2EA44F)

> A secure AWS web deployment built from a custom VPC through EC2, Nginx, DNS, HTTPS, logging and external security validation.

[← Month 1: AWS Organisation and IAM Foundation](../Month%201/README.md) ·
[Portfolio Home](../README.md)

---

## Project Overview

Month 2 continues the VinceOps Cloud infrastructure journey established in Month 1.

After creating the AWS organisation and workforce-access foundation, this phase focused on deploying a secure internet-facing website inside a custom AWS network.

The project covered:

- custom VPC networking;
- public subnet configuration;
- internet routing;
- EC2 deployment;
- Ubuntu server administration;
- Nginx web hosting;
- website-file deployment;
- DNS configuration;
- HTTPS certificate installation;
- VPC Flow Logs;
- external security testing.

---

## Architecture

[![VinceOps Month 2 AWS Architecture](./diagrams/network-web-architecture.png)](./diagrams/network-web-architecture.png)

[View the full-size architecture diagram](./diagrams/network-web-architecture.png)

### Deployment Path

```text
User
  │
  ▼
DNS: vinceops.site
  │
  ▼
Internet Gateway
  │
  ▼
Public Route Table
  │
  ▼
Public Subnet
  │
  ▼
Security Group
  │
  ▼
Amazon EC2
  │
  ▼
Ubuntu and Nginx
  │
  ▼
HTTPS Website
```

### Logging Path

```text
VPC Network Activity
        │
        ▼
VPC Flow Logs
        │
        ▼
Amazon S3
```

---

## What I Built

| Layer | Implementation |
|---|---|
| Network | Custom Amazon VPC |
| VPC CIDR | `10.0.0.0/16` |
| Subnet | Public subnet |
| Subnet CIDR | `10.0.1.0/24` |
| Internet access | Internet Gateway |
| Routing | Public route table with `0.0.0.0/0` route |
| Network security | Security group and Network ACL |
| Compute | Ubuntu Amazon EC2 instance |
| Instance type | `t2.medium` |
| Storage | 20 GB |
| Server access | SSH key-pair authentication |
| Web server | Nginx |
| Website directory | `/var/www/html` |
| Domain | `vinceops.site` |
| HTTPS | Certbot and Let’s Encrypt |
| Certificate coverage | `vinceops.site` and `www.vinceops.site` |
| Network logging | VPC Flow Logs |
| Log destination | Amazon S3 |
| Security validation | External port scanning |

---

## Network Foundation

A custom Amazon VPC was created to provide the network boundary for the deployment.

The network included:

- a public subnet;
- an Internet Gateway;
- a public route table;
- an active internet route;
- an explicit subnet association;
- security-group controls;
- Network ACL association;
- VPC Flow Logs.

The public route table included:

```text
0.0.0.0/0 → Internet Gateway
```

This provided the required internet path for the EC2 web server.

---

## EC2 Deployment

An Ubuntu EC2 instance was launched inside the VinceOps VPC and public subnet.

The instance was configured with:

```text
Instance type: t2.medium
Storage: 20 GB
Operating system: Ubuntu Linux
Access method: SSH key pair
Metadata protection: IMDSv2
```

The server was accessed remotely through SSH for installation and configuration.

---

## Nginx Web Server

Nginx was installed and started on the Ubuntu server:

```bash
sudo apt update -y
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
```

The service was validated using:

```bash
sudo systemctl status nginx
curl -I http://localhost
```

The customized VinceOps website files were deployed to:

```text
/var/www/html
```

---

## DNS Configuration

A DNS A record was configured for:

```text
vinceops.site
```

DNS propagation was checked across multiple global DNS resolvers before completing the HTTPS configuration.

---

## HTTPS Configuration

Certbot and the Nginx plugin were installed:

```bash
sudo apt install certbot -y
sudo apt install python3-certbot-nginx -y
```

A Let’s Encrypt certificate was configured for:

```text
vinceops.site
www.vinceops.site
```

The certificate was deployed through Nginx using:

```bash
sudo certbot --nginx -d vinceops.site -d www.vinceops.site
```

The completed website was successfully accessed through HTTPS.

---

## Network Logging

VPC Flow Logs were enabled to provide visibility into network traffic.

The Flow Logs were configured to capture traffic metadata and deliver it to an Amazon S3 bucket.

This provided an additional source of network evidence for monitoring and troubleshooting.

---

## Security Validation

An authorised external port scan was performed against the VinceOps domain.

### Initial Scan

The initial result identified:

| Port | Service | State |
|---:|---|---|
| 80 | HTTP | Open |
| 443 | HTTPS | Open |

### Follow-Up Scan

After reviewing the public exposure, a second scan identified:

| Port | Service | State |
|---:|---|---|
| 443 | HTTPS | Open |

This confirmed that the publicly observed web exposure had been reduced to HTTPS.

---

## Implementation Evidence

Sanitized implementation screenshots are available in the evidence register:

[View Month 2 Screenshot Evidence](./screenshots/README.md)

The evidence includes:

- public subnet creation;
- route-table association;
- Internet Gateway routing;
- VPC Flow Logs;
- EC2 deployment;
- SSH access;
- Nginx validation;
- DNS propagation;
- Certbot installation;
- HTTPS certificate deployment;
- live website validation;
- security scan results.

---

## Project Documentation

| Document | Description |
|---|---|
| [Network and Web Architecture](./network-web-architecture.md) | Detailed architecture and implementation |
| [Architecture Decisions](./decisions.md) | Design decisions and technical reasoning |
| [Security Testing](./security-testing.md) | External scan results and validation |
| [Serverless Hosting Bonus](./serverless-bonus.md) | Additional hosting exercise |
| [Screenshot Evidence](./screenshots/README.md) | Sanitized implementation evidence |
| [Architecture Diagram](./diagrams/network-web-architecture.png) | Visual representation of the deployment |

---

## Skills Demonstrated

- AWS VPC design
- Public subnet configuration
- Internet Gateway routing
- Route-table association
- Amazon EC2 deployment
- Ubuntu Linux administration
- SSH access
- Nginx installation
- Website deployment
- DNS configuration
- Certbot and Let’s Encrypt
- HTTPS configuration
- VPC Flow Logs
- Amazon S3
- Security testing
- Technical documentation

---

## Outcome

Month 2 delivered a complete AWS network-to-HTTPS deployment.

The project successfully connected:

```text
AWS Network
    │
    ▼
EC2 Compute
    │
    ▼
Nginx Web Server
    │
    ▼
DNS and HTTPS
    │
    ▼
Security Validation
```

---

## Navigation

[← Month 1: AWS Organisation and IAM Foundation](../Month%201/README.md) ·
[Portfolio Home](../README.md) ·
[Architecture](./network-web-architecture.md) ·
[Decisions](./decisions.md) ·
[Security Testing](./security-testing.md) ·
[Evidence](./screenshots/README.md)
