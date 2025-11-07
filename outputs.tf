output "aws_instance_public_dns" {
  value = aws_instance.ubuntu.public_dns
  description = "Public DNS hostname of Ec2 instance"
}

output "aws_vpc_id" {
  value = aws_vpc.app.id
  description = "ID of the public vpc"
}

output "aws_subnet_id" {
  value = aws_subnet.public_subnet1.id
  description = "ID of the public subnet"
}