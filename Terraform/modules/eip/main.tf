resource "aws_eip" "this" {
  domain = "vpc"
  tags = {
    name = "${var.az}-${var.name}"
  }
}
