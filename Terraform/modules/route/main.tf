resource "aws_route_table" "this" {
  vpc_id = var.vpc_id


  dynamic "route" {
    for_each = var.is_public ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = var.igw_id
    }
  }

  dynamic "route" {
    for_each = var.is_public ? [] : [1]
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = var.nat_id
    }
  }
  tags = {
    Name = "${var.name}-${var.is_public ? "public" : "private"}-rt${var.az != null ? "-${var.az}" : ""}"
  }
}


resource "aws_route_table_association" "private" {
  for_each = toset(var.subnet_id)

  subnet_id      = each.value
  route_table_id = aws_route_table.this.id
}
