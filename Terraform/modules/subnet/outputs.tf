output "subnet_id" {
  description = "subnet_id"
  value       = aws_subnet.subnet.id
}

output "subnet_cidr" {
  description = "subnet cidr"
  value       = aws_subnet.subnet.cidr_block
}

output "az" {
  description = "subent az"
  value       = var.availability_zones
}
