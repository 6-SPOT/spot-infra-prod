output "eip-allocation_id" {
  description = "eip-allocation_id"
  value = aws_eip.this.allocation_id
}

output "eip-association_id" {
  description = "eip-association_id"
  value = aws_eip.this.association_id
}