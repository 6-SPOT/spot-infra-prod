output "nat_info" {
  description = "NAT Gateway 정보 모음"
  value = {
    id                   = aws_nat_gateway.this.id
    public_ip            = aws_nat_gateway.this.public_ip
    allocation_id        = aws_nat_gateway.this.allocation_id
    association_id       = aws_nat_gateway.this.association_id
    network_interface_id = aws_nat_gateway.this.network_interface_id
    az                   = var.az
  }
}
