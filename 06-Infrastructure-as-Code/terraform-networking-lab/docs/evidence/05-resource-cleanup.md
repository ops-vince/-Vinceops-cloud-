# Terraform Resource Cleanup — Validation

## Objective

Demonstrate safe teardown of temporary AWS infrastructure
using Terraform.

## Resources managed during the lab

- AWS VPC
- Two public subnets
- Two private subnets
- Internet Gateway
- Public and private route tables
- Public internet route
- Route table associations
- HTTP and SSH security groups
- EC2 SSH key pair
- Ubuntu EC2 instance

## Cleanup command

terraform destroy -var="ssh_allowed_cidr=<authorized-public-ip>/32"

## Observed result

Destroy complete! Resources: 17 destroyed.

The Terraform output confirmed successful destruction
of the EC2 instance, SSH key pair, security groups,
subnets, routing resources, Internet Gateway and VPC.

## Engineering significance

- Demonstrated infrastructure teardown using Terraform.
- Followed the dependencies between AWS resources.
- Preserved configuration files for future reproduction.
- Removed temporary cloud infrastructure after testing.

## Status

PASSED

## Scope

This result confirms destruction of the resources
managed by this Terraform lab, not unrelated AWS resources.
