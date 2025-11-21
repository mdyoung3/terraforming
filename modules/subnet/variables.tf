variable "subnet_cidr_block" {
  type = string
  description = "CIDR Block for our vpc resource"
  default     = "10.0.0.0/16"
}

variable "aws_region" {
  type = string
  description = "A definition of the region or regions."
  default = "us-east-1"
}

variable "vpc_cipr_block" {
  type = string
  description = ""
  default = "10.0.0.0/16"
}

variable "public_ip_on_launch" {
  type        = bool
  description = "sets the boolean value for mapping of public ip"
  default     = true
}

variable "availability_zone" {
  type = string
  description = "Availability zone for the subnet"
}

variable "vpc_id" {
  description = "VPC ID where subnet will be created"
  type        = string
}