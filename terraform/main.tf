provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.0.0/24"
}

resource "aws_security_group" "client_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "client" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.main.id
  security_groups = [aws_security_group.client_sg.name]

  tags = {
    Name = "ClientInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Installing Docker..."
              apt-get update
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              echo "Docker installed."
              EOF
}

output "client_public_ip" {
  value = aws_instance.client.public_ip
}
