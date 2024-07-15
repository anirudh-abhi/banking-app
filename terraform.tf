# Specify the provider
provider "aws" {
  region = "us-west-1"
}

# Create a security group to allow SSH and HTTP access
resource "aws_security_group" "web_sg" {
  name_prefix = "web-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0  # Changed from 0.0.0.0/0 to 0
    to_port     = 0  # Changed from 0.0.0.0/0 to 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance
resource "aws_instance" "web" {
  ami             = "ami-0e41ff7d11ac11810"  # Update with your preferred AMI ID
  instance_type   = "t2.medium"
  key_name        = "next one.pem"  # Update with your key pair name
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "testing-server"
  }

  # Optionally add a block device mapping to use EBS storage
  root_block_device {
    volume_type = "gp2"
    volume_size = 10
  }

  # Optionally add a user data script to configure the instance at launch
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World! its testing server" > /var/www/html/index.html
              EOF
}

# Output the public IP address of the instance
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
