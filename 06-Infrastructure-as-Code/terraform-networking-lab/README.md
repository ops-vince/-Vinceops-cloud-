# VinceOps Terraform AWS Networking Lab

## Purpose

This project develops and documents foundational Terraform skills by
defining an AWS network that can later inform the larger EKS capstone.

## Architecture

The configuration defines:

- One VPC with CIDR range 10.20.0.0/16.
- Two public subnets in separate availability zones.
- Two private subnets in separate availability zones.
- One Internet Gateway.
- A public route table with a default route through the Internet Gateway.
- A private route table without a default internet route.
- Route table associations for all four subnets.
- Resource tags to identify the project and support future Kubernetes use.

## Deliberate limitations

This initial lab does not create an EKS cluster, NAT Gateway, load balancer,
EC2 instance, database, or security group.

The private subnets have no NAT Gateway or default internet route. The
public subnets have a route to the Internet Gateway, but internet access
also depends on other network and security settings.

No AWS resources are created during initialization or validation.

## Prerequisites

- Terraform installed.
- AWS CLI installed.
- An authenticated AWS SSO profile named vinceops-terraform-lab.
- Permission to inspect and create the required networking resources
  in us-east-1.

## Validate the configuration

Run these commands from the repository root:

    terraform -chdir=06-Infrastructure-as-Code/terraform-networking-lab init
    terraform -chdir=06-Infrastructure-as-Code/terraform-networking-lab fmt -check
    terraform -chdir=06-Infrastructure-as-Code/terraform-networking-lab validate

## Plan and deployment

Before planning, confirm the AWS identity and review the proposed changes.

    aws sts get-caller-identity --profile vinceops-terraform-lab
    terraform -chdir=06-Infrastructure-as-Code/terraform-networking-lab plan

Do not apply changes until the plan and the account permissions have been
reviewed. The initial lab uses local Terraform state and is intended for
individual learning, not concurrent team deployments.

## Cleanup

After any deployment, inspect the resources and Terraform state before
destroying the lab. Run destroy only when you have confirmed that the
resources belong to this project and are safe to remove.

    terraform -chdir=06-Infrastructure-as-Code/terraform-networking-lab destroy

## Deployment Screenshots

Original screenshots from the completed Terraform lab:

[View Terraform Deployment Evidence](./docs/evidence/screenshots/README.md)
