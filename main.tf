# Provider configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0"
    }
  }
}
provider "aws" {
  region = "us-east-1" 
}
data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}


# Security Group
resource "aws_security_group" "debian_sg" {
  name        = "debian-instance-sg"
  description = "Security group for Debian EC2 instance"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "bryan-security-group"
  }
}
resource "aws_key_pair" "debian_key" {
  key_name   = "debian-key"
  public_key = file("~/.ssh/id_rsa.pub")  # Altere para o caminho da sua chave pública
}
resource "aws_instance" "debian" {
  ami           = data.aws_ami.debian.id
  instance_type = "t3.micro" 
  key_name               = aws_key_pair.debian_key.key_name
  vpc_security_group_ids = [aws_security_group.debian_sg.id]
  subnet = subnet-08ab1cc11d069cf59
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash
              yum update -y ; yum install -y git 
              systemctl enable git ; systemctl start git
              git clone https://github.com/BryanPacker/proway-docker.git
  tags = {
    Name = "debian-instance"
  }
}
# Outputs
output "instance_id" {
  description = "ID da instância EC2"
  value       = aws_instance.debian.id
}

output "instance_public_ip" {
  description = "IP público da instância"
  value       = aws_eip.debian_eip.public_ip
}

output "instance_public_dns" {
  description = "DNS público da instância"
  value       = aws_instance.debian.public_dns
}

output "ssh_connection" {
  description = "Comando SSH para conectar"
  value       = "ssh -i ~/.ssh/id_rsa admin@${aws_eip.debian_eip.public_ip}"
}
