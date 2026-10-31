variable "project_name" {
  description = "Name used to identify this Terraform networking lab."
  type        = string
  default     = "vinceops-terraform-lab"
}

variable "aws_profile" {
  description = "AWS CLI profile configured for the development account."
  type        = string
  default     = "vinceops-terraform-lab"
}

variable "aws_region" {
  description = "AWS region in which resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR range allocated to the VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR ranges for the two public subnets."
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Provide exactly two public subnet CIDR ranges."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR ranges for the two private subnets."
  type        = list(string)
  default     = ["10.20.11.0/24", "10.20.12.0/24"]

  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Provide exactly two private subnet CIDR ranges."
  }
}
