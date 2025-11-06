# Provider in Terraform is a plugin that allows Terraform to interact with a specific cloud platform, service, or API.
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Arguments for provider: Region, credentials, etc...
provider "aws" {
  region = "us-east-1"
}

# A way to query information from a platorm or service. Similar to resources.
data "aws_ssm_parameter" "ubuntu" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

# Resource takes to parameters: Resource type (aws_vpc) and name label (app).
resource "aws_vpc" "app" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

# vpc_id references the above resource
resource "aws_internet_gateway" "app" {
  vpc_id = aws_vpc.app.id
}

resource "aws_subnet" "public_subnet1" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.app.id
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

# Routing
resource "aws_route_table" "app" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app.id
  }
}

resource "aws_route_table_association" "app_subnet1" {
  subnet_id = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.app.id
}

#security groups
resource "aws_security_group" "apache_sg" {
  name = "apache_sg"
  vpc_id = aws_vpc.app.id

  #http access
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Nonsensitive function removes sensitive values and allows us to use the value here.
resource "aws_instance" "ubuntu" {
  ami = nonsensitive(data.aws_ssm_parameter.ubuntu.value)
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.apache_sg.id]
  user_data_replace_on_change = true

  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt install apache2 -y
sudo systemctl start apache2
sudo cat > /var/www/html/index.html << 'WEBSITE
<html>
<head>
  <title>From the edge of the Jellobelt</title>
</head>
<body>
  <p style="text-align:center;">Welcome to the Edge of the Jellobelt</p>
</body>
</html>
WEBSITE
EOF
}
