resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidrs
  availability_zone       = var.availability_zones
  map_public_ip_on_launch = var.public

  tags = {
    Name = var.tag
  }
}
