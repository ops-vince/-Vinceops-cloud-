# Terraform Lab — Operations Reference

This document is a reproduction reference for the completed [Terraform Networking and EC2 Lab](../README.md). It is separate from the engineering case study, which records outcomes and evidence.

## Environment and authentication

- AWS region: `us-east-1`
- AWS CLI profile: `vinceops-terraform-lab` (an account-specific IAM Identity Center profile)
- Local SSH public key: `~/.ssh/vinceops-terraform-lab.pub`
- Terraform state: local; not shared or suitable for concurrent multi-operator use

On WSL, AWS SSO may be authorized from a Windows browser using the device-code flow. The `gio` browser-launch error does not by itself mean SSO login failed.

```bash
aws sso login --profile vinceops-terraform-lab --use-device-code
aws sts get-caller-identity --profile vinceops-terraform-lab
```

## Initialization and checks

The following examples run inside `06-Infrastructure-as-Code/terraform-networking-lab/`.

```bash
terraform init
terraform fmt -check
terraform validate
```

## Planning and deployment

The SSH variable is required; it should contain the actual public address of the workstation used for SSH (CIDR `/32`). If the address changes, the security-group plan may change.

```bash
MY_IP="$(curl -4 -fsS https://checkip.amazonaws.com | tr -d '\r\n')"
terraform plan -var="ssh_allowed_cidr=${MY_IP}/32" -out=tfplan
terraform apply tfplan
```

The EC2 application used HTTP on port 80 in this lab. HTTP and SSH were verified separately; HTTPS was **not** configured for this Terraform workload.

```bash
terraform output ec2_public_ip
terraform output ec2_ssh_command
curl -I "http://$(terraform output -raw ec2_public_ip)"
```

## Desired-state checks and teardown

After a successful apply, a second plan documented idempotency. An EC2 tag was changed, applied in place, and validated with another no-change plan. The final lab teardown was completed using `terraform destroy`.

To reproduce the teardown on a separate run, first verify the active AWS account and the proposed resources: destroying this configuration removes the resources in its **current** Terraform state.

```bash
aws sts get-caller-identity --profile vinceops-terraform-lab
terraform state list
terraform destroy -var="ssh_allowed_cidr=${MY_IP}/32"
terraform state list
```

**Historical outcome:** `Destroy complete! Resources: 17 destroyed.` See [cleanup evidence](./evidence/validation/05-resource-cleanup.md) and [terminal screenshot](./evidence/screenshots/11-terraform-destroy-success.png). Reproduction of these commands is not necessary to verify the original result.

## Operational boundaries

The example configuration uses public HTTP, allows unrestricted outbound traffic, uses a single EC2 instance, and has no NAT Gateway for private subnet egress. These are lab-specific boundaries, not production deployment recommendations. The SSO profile and SSH public key are not created by Terraform and must exist on the operator machine.
