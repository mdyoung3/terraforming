# Provider in Terraform is a plugin that allows Terraform to interact with a specific cloud platform, service, or API.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# A way to query information from a platorm or service. Similar to resources.
data "aws_ssm_parameter" "ubuntu" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

# Arguments for provider: Region, credentials, etc...
provider "aws" {
  region = var.aws_region
}

module "public_subnet_1" {
  source = "./modules/subnet"

  subnet_cidr_block   = "10.0.1.0/24"
  vpc_id              = aws_vpc.app.id
  availability_zone   = "us-east-1a"
  public_ip_on_launch = true
  subnet_name         = "public-subnet-1"

  tags = {
    Environment = "dev"
    Project     = "webapp"
  }
}

# Resource takes to parameters: Resource type (aws_vpc) and name label (app).
# This is networking
resource "aws_vpc" "app" {
  cidr_block           = var.vpc_cipr_block
  enable_dns_hostnames = true
  tags                 = merge(local.common_tags, {Name = lower("${local.prefix}-vpc")})
}

# vpc_id references the above resource
resource "aws_internet_gateway" "app" {
  vpc_id = aws_vpc.app.id

  tags = local.common_tags
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
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.app.id
}

#security groups
resource "aws_security_group" "apache_sg" {
  name   = "apache_sg"
  vpc_id = aws_vpc.app.id

  #http access
  ingress {
    from_port   = var.ingress_inbound_http
    to_port     = var.ingress_inbound_http
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #ssh access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Or restrict to your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/terraform_key.pub") # Reads the public key
}

# Nonsensitive function removes sensitive values and allows us to use the value here.
resource "aws_instance" "ubuntu" {
  ami                         = nonsensitive(data.aws_ssm_parameter.ubuntu.value)
  instance_type               = var.instance_type
  subnet_id = module.public_subnet_1.subnet_id
  # subnet_id                   = aws_subnet.public_subnet1.id
  vpc_security_group_ids      = [aws_security_group.apache_sg.id]
  key_name                    = aws_key_pair.terraform_key.key_name
  user_data_replace_on_change = true
  user_data = templatefile("templates/startup_script.tpl", { environment = var.environment })

  tags                 = merge(local.common_tags, {Name = lower("${local.prefix}-ec2")})
}
