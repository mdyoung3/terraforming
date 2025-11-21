resource "aws_subnet" "public_subnet1" {
  cidr_block              = var.subnet_cidr_block
  vpc_id                  = var.vpc_id
  availability_zone       = var.availability_zone # "us-east-1a"
  map_public_ip_on_launch = var.public_ip_on_launch

    tags = merge(
      var.tags,
      {
        Name = var.subnet_name
      }
    )
}

# resource "aws_subnet" "public_subnet1" {
#   cidr_block              = var.subnet_cidr_block
#   vpc_id                  = var.vpc_id  # Pass this in as a variable
#   availability_zone       = var.availability_zone
#   map_public_ip_on_launch = var.public_ip_on_launch
#
#   tags = merge(
#     var.tags,
#     {
#       Name = var.subnet_name
#     }
#   )
# }
