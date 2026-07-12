# Month 2: AWS Network and Secure Web Deployment

![AWS](https://img.shields.io/badge/AWS-VPC%20%7C%20EC2-FF9900?logo=amazonaws&logoColor=white)
![Ubuntu](https://img.shields.io/badge/OS-Ubuntu-E95420?logo=ubuntu&logoColor=white)
![Nginx](https://img.shields.io/badge/Web%20Server-Nginx-009639?logo=nginx&logoColor=white)
![HTTPS](https://img.shields.io/badge/Security-HTTPS-2EA44F)
![Status](https://img.shields.io/badge/Status-Completed-2EA44F)

> A secure AWS web deployment built from a custom VPC through EC2, Nginx, DNS, HTTPS, network logging and external security validation.

---

## Project Overview

Month 2 continues the VinceOps Cloud infrastructure journey established in Month 1.

After creating the AWS organisation and workforce-access foundation, this phase focused on deploying an internet-facing website inside a custom AWS network.

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

[Open the full architecture diagram](./diagrams/network-web-architecture.png)

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
- a security group;
- a Network ACL association;
- VPC Flow Logs.

The public route table included:

```text
0.0.0.0/0 → Internet Gateway
```

### Network Evidence

- [Public subnet created](./%20screenshots/01-public-subnet-created.png)
- [Route-table and subnet association](./%20screenshots/02-route-table-subnet-association.png)
- [Internet Gateway route](./%20screenshots/03-public-route-to-internet-gateway.png)
- [VPC Flow Logs active](./%20screenshots/04-vpc-flow-logs-active.png)

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

[View the EC2 instance evidence](./%20screenshots/05-ec2-instance-summary.png)

---

## Secure Server Access

The EC2 instance was administered through key-based SSH authentication.

The server was prepared using:

```bash
sudo apt update -y
sudo apt upgrade -y
```

[View the SSH access evidence](./%20screenshots/06-ssh-access-success.png)

---

## Nginx Web Server

Nginx was installed and started on the Ubuntu server:

```bash
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

[View the Nginx validation evidence](./%20screenshots/07-nginx-active-http-response.png)

---

## DNS Configuration

A DNS A record was configured for:

```text
vinceops.site
```

DNS propagation was checked across multiple public DNS resolvers before completing the HTTPS configuration.

[View the DNS propagation evidence](./%20screenshots/08-dns-propagation-vinceops-site.png)

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

### HTTPS Evidence

- [Certbot installation](./%20screenshots/9-certbot-installed.png)
- [Certificate issued](./%20screenshots/10-certbot-certificate-issued.png)
- [Root and `www` certificate coverage](./%20screenshots/11-certificate-expanded-root-and-www.png)
- [Certificate details](./%20screenshots/12-https-certificate-detail.png)
- [HTTPS website deployment](./%20screenshots/13-vinceops-site-https-deployed.png)

---

## Network Logging

VPC Flow Logs were enabled to capture network traffic metadata.

The Flow Logs were configured with an Amazon S3 destination for storage and review.

[View the VPC Flow Log evidence](./%20screenshots/04-vpc-flow-logs-active.png)

---

## Security Validation

An authorised external port scan was performed against the VinceOps domain.

### Initial Scan

| Port | Service | State |
|---:|---|---|
| 80 | HTTP | Open |
| 443 | HTTPS | Open |

- [View the initial scan screenshot](./%20screenshots/14-port-scan-before-http-and-https.png)
- [View the initial scan report](./%20screenshots/%20security-reports/port-scan-before-http-and-https.png)

### Follow-Up Scan

| Port | Service | State |
|---:|---|---|
| 443 | HTTPS | Open |

[View the follow-up scan report](./%20screenshots/%20security-reports/port-scan-after-https-only.png)

The follow-up scan confirmed that the publicly observed web exposure had been reduced to HTTPS.

---

## Implementation Evidence

The screenshot evidence register contains the complete sanitized implementation sequence.

[View the Month 2 Screenshot Evidence Register](./%20screenshots/README.md)

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
- website validation;
- initial and follow-up security scans.

---

## Project Documentation

| Document | Description |
|---|---|
| [Network and Web Architecture](./diagrams/network-web-architecture.png) | View the AWS network-to-HTTPS architecture |
| [Architecture Decisions](./decisions.md) | Design decisions and technical reasoning |
| [Security Testing](./security-testing.md) | External scan and validation process |
| [Serverless Hosting Bonus](./serverless-bonus.md) | Additional hosting exercise |
| [Screenshot Evidence](./screenshots/README.md) | Sanitized implementation evidence |

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
[Serverless Bonus](./serverless-bonus.md) ·
[Evidence](./%20screenshots/README.md)
