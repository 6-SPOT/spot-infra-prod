output "public_sub" {
  value = local.public_subnet_ids_by_az
}

output "eip_list" {
  value = local.nat_eip_ids_by_az
}

output "all_public_subnet_ids" {
  value = local.all_public_subnet_ids
}

output "all_nat" {
  value = local.nat_info_by_az
}

output "sg_list" {
  value = local.sg_list
}

output "tg_list" {
  value = local.tg_arns
}

output "asg_config" {
  value = local.asg_config_merge
}
