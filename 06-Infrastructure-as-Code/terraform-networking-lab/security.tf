resource "aws_security_group" "web" {
  name        = "vinceops-terraform-lab-web-sg"
  description = "Allow HTTP for the Terraform networking lab"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "vinceops-terraform-lab-web-sg"
    Project     = "vinceops-terraform-lab"
    Environment = "learning"
    ManagedBy   = "Terraform"
  }
}

output "web_security_group_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web.id
}
