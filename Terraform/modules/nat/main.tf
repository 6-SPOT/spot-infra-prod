resource "aws_nat_gateway" "this" {
  subnet_id     = var.pub_sub
  allocation_id = var.allocation_id
  tags = {
    Name = "${var.name}-natGate-${var.az}"
  }
}
