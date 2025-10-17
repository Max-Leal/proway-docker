resource "aws_security_group" "sgDoMax" {
  name        = var.security_group_name
  description = "Security group para a pizzaria"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # "0.0.0.0/0" significa "qualquer IP"
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress = {
    description = "Porta da api"
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "instance-max" {

  ami                         = var.ami_id
  instance_type               = var.instance_type 
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.sgDoMax.id]
  associate_public_ip_address = true
  key_name = "ec2-max"
  user_data                   = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y make
              make requirements
              make run
              
              EOF

  tags = {
    Name = "ec2-pizzaria-max"
  }
}
