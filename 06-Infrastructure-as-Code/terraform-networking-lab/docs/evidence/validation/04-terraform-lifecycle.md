# Terraform Lifecycle Management — Validation

## Objective

Demonstrate that Terraform can update existing AWS infrastructure
without unnecessarily replacing resources.

## Initial state

After provisioning and testing the EC2 server, Terraform reported:

No changes. Your infrastructure matches the configuration.

## Controlled modification

Added the following tag to the existing EC2 resource:

Validation = terraform-lifecycle-tested

## Terraform plan

Terraform identified an in-place update to aws_instance.web.

Plan: 0 to add, 1 to change, 0 to destroy.

## Apply result

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

The existing EC2 instance was modified without replacement.

## Final verification

Executed terraform plan using the authorized SSH CIDR.

Observed result:

No changes. Your infrastructure matches the configuration.

## Engineering significance

- Demonstrated Terraform desired-state management.
- Applied a controlled infrastructure change.
- Verified that the EC2 instance did not require replacement.
- Confirmed that Terraform returned to a consistent state.

## Status

PASSED
