variable "ssh_allowed_cidr" {
  description = "Your public IPv4 address in CIDR notation, ending in /32"
  type        = string
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_key_pair" "lab" {
  key_name   = "vinceops-terraform-lab-ssh-key"
  public_key = file(pathexpand("~/.ssh/vinceops-terraform-lab.pub"))

  tags = {
    Name      = "vinceops-terraform-lab-ssh-key"
    ManagedBy = "Terraform"
    Project   = "vinceops-terraform-lab"
  }
}

resource "aws_security_group" "ssh" {
  name        = "vinceops-terraform-lab-ssh-sg"
  description = "Restricted SSH access for the Terraform EC2 lab"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from the authorized public IPv4 address"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "vinceops-terraform-lab-ssh-sg"
    ManagedBy = "Terraform"
    Project   = "vinceops-terraform-lab"
  }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.web.id, aws_security_group.ssh.id]
  key_name                    = aws_key_pair.lab.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  user_data = <<-EOF
    #!/bin/bash
    set -eux
    apt-get update -y
    apt-get install -y nginx
    systemctl enable --now nginx
    echo '<h1>VinceOps Terraform Networking Lab</h1>' > /var/www/html/index.html
  EOF

  tags = {
    Name        = "vinceops-terraform-lab-ec2"
    Validation  = "terraform-lifecycle-tested"
    Environment = "learning"
    ManagedBy   = "Terraform"
    Project     = "vinceops-terraform-lab"
  }
}

output "ec2_public_ip" {
  description = "Public IPv4 address of the lab server"
  value       = aws_instance.web.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS name of the lab server"
  value       = aws_instance.web.public_dns
}

output "ec2_ssh_command" {
  description = "SSH command for connecting to the Ubuntu server"
  value       = "ssh -i ~/.ssh/vinceops-terraform-lab ubuntu@${aws_instance.web.public_ip}"
}
