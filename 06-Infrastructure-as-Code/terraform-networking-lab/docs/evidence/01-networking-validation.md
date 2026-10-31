# AWS Networking Validation

## Objective

Provision and verify a two-Availability-Zone AWS network using Terraform.

## Infrastructure

- Region: us-east-1
- VPC CIDR: 10.20.0.0/16
- Public subnet 1: 10.20.1.0/24
- Public subnet 2: 10.20.2.0/24
- Private subnet 1: 10.20.11.0/24
- Private subnet 2: 10.20.12.0/24
- Availability Zones: us-east-1a and us-east-1b
- Internet Gateway
- Public and private route tables
- HTTP security group

## Validation

Terraform initial networking deployment:

13 resources added, 0 changed, 0 destroyed.

AWS CLI verification confirmed:

- All four subnets existed in the intended VPC.
- Public subnets were associated with the public route table.
- The public route table had an active default route through the Internet Gateway.
- Private subnets were associated with the private route table.
- The private route table contained only the local VPC route.
- Public IP auto-assignment was enabled only for public subnets.

## Architecture Decisions

The lab separates public and private network tiers.

No NAT Gateway was deployed. Private subnet workloads therefore
had no direct outbound internet route in this configuration.

## Result

PASSED

All networking resources were subsequently removed through
the successful Terraform destroy operation.
