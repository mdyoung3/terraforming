variable "aws_region" {
  type        = string
  description = "A list of regions"
  default     = "us-east-1"
}

variable "vpc_cipr_block" {
  type        = string
  description = "CIDR Block for our vpc resource"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  type        = string
  description = "CIDR Block information for the subnet of our vpc"
  default     = "10.0.0.0/24"
}

variable "ingress_inbound_http" {
  type        = string
  description = "Sets port(s) for incoming connections"
}

variable "instance_type" {
  type        = string
  description = "Sets the instance for this resource"
}

variable "public_ip_on_launch" {
  type        = bool
  description = "sets the boolean value for mapping of public ip"
  default     = true
}

variable "company_name" {
  type        = string
  description = "Name of the company"
  default     = "jellobelt"
}

variable "project" {
  type        = string
  description = "The name of the project"
}

variable "environment" {
  type        = string
  description = "The environment for deploying (dev, test, prod)"
}

variable "billing_code" {
  type        = string
  description = "The billing code of the project"
}

variable "protocol" {
  type        = string
  description = "The protocol (http or https) the resource can connect to"
  default     = "http"
}
