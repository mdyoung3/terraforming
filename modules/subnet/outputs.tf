output "subnet_id" {
  description = "ID of the created subnet"
  value       = aws_subnet.public_subnet1.id
}

output "subnet_cidr" {
  description = "CIDR block of the subnet"
  value       = aws_subnet.public_subnet1.cidr_block
}

output "availability_zone" {
  description = "AZ of the subnet"
  value       = aws_subnet.public_subnet1.availability_zone
}
