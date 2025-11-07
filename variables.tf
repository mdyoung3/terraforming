variable "aws_region" {
  type = string
  description = "A list of regions"
  default = 'us-east-1'
}

variable "vpc_cipr_block" {
  type = string
  description = "CIDR Block for our vpc resource"
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  type = string
  description = "CIDR Block information for the subnet of our vpc"
  default = "10.0.0.0/24"
}

variable "ingress_inbound_http" {
  type = string
  description = "Sets ports for incoming connections"
}

variable "instance_type" {
  type = string
  description = "Sets the instance for this resource"
}
