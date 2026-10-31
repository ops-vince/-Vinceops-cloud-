# VinceOps Terraform Lab — EC2 Deployment and Validation

## Objective

Deploy a public-facing Ubuntu EC2 instance using Terraform,
configure Nginx automatically and verify connectivity.

## Infrastructure

- AWS Region: us-east-1
- VPC CIDR: 10.20.0.0/16
- Instance type: t2.micro
- Operating system: Ubuntu 24.04
- Root EBS volume: 8 GB gp3, encrypted
- Deployment subnet: First public subnet
- HTTP access: TCP port 80
- SSH access: TCP port 22 restricted to an authorized /32
- SSH key: Registered using Terraform
- Web server: Nginx

## Provisioning Results

Terraform successfully created:
- AWS EC2 key pair
- EC2 instance
- Restricted SSH security group (created during an earlier
  partial apply)

Final EC2 deployment result:
2 resources added, 0 changed, 0 destroyed.

## Verification Results

| Test | Observed Result |
|---|---|
| SSH connection | Successful |
| Cloud-init | status: done |
| Nginx service | active |
| Local HTTP | HTTP/1.1 200 OK |
| External HTTP | HTTP/1.1 200 OK |
| Application content | VinceOps Terraform Networking Lab |

## Troubleshooting

The initial deployment encountered an IAM authorization
failure for ec2:ImportKeyPair.

The IAM Identity Center permission set was updated.
An AWS CLI dry-run returned DryRunOperation, confirming
that the key import permission was effective.

Terraform subsequently created the EC2 key pair and
instance successfully.

## Engineering Lessons

- Terraform applies infrastructure declaratively.
- IAM permissions determine which AWS API operations
  Terraform can execute.
- Partial applies can create some resources before an
  authorization failure.
- Terraform state allows subsequent applies to continue
  from the recorded infrastructure.
- EC2 user data can automate server initialization.
- A public subnet and Internet Gateway support routing,
  while security groups control allowed instance traffic.
- Infrastructure must be verified after provisioning.

## Next Steps

- Verify Terraform idempotency
- Demonstrate a controlled infrastructure update
- Capture final evidence
- Destroy temporary AWS resources
- Finalize project README
