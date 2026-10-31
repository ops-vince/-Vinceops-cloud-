# 06 — Infrastructure as Code with Terraform

## Overview

This milestone demonstrates infrastructure provisioning,
validation, controlled updates and teardown using Terraform
and AWS.

The implementation was tested in the VinceOps development
account in us-east-1.

## Completed project

[Terraform Networking and EC2 Lab](./terraform-networking-lab/README.md)

## Architecture

- Custom VPC: 10.20.0.0/16
- Two public subnets across two Availability Zones
- Two private subnets across two Availability Zones
- Internet Gateway and public routing
- Private routing without a NAT Gateway
- HTTP and restricted SSH security groups
- Ubuntu EC2 instance with encrypted EBS storage
- Nginx installation automated through EC2 user data

## Engineering validation

- AWS networking provisioned and verified
- EC2 instance provisioned through Terraform
- SSH connectivity verified
- Cloud-init completed successfully
- Nginx active and HTTP 200 responses confirmed
- Terraform idempotency verified
- EC2 tags updated in place without replacement
- All 17 managed AWS resources successfully destroyed

## Evidence

The implementation, validation, troubleshooting and cleanup
records are available in the
[lab evidence directory](./terraform-networking-lab/docs/evidence/).

## Scope

This was a temporary AWS learning lab, not a persistent
production deployment. EKS infrastructure automation will
be addressed in the integrated capstone.
