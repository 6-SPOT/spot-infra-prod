module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.vpc_cidr
  name       = var.name
}

module "public_sub" {
  for_each = var.public_sub
  source   = "./modules/subnet"

  vpc_id             = module.vpc.vpc_id
  subnet_cidrs       = each.value.cidr
  availability_zones = each.value.az
  public             = each.value.public
  tag                = each.key
}

module "private_sub" {
  for_each = var.private_sub
  source   = "./modules/subnet"

  vpc_id             = module.vpc.vpc_id
  subnet_cidrs       = each.value.cidr
  availability_zones = each.value.az
  public             = each.value.public
  tag                = each.key
}

module "igw" {
  source = "./modules/igw"

  vpc_id = module.vpc.vpc_id
  name   = var.name
}

module "nat-eip" {
  for_each = local.priavte_subnet_ids_by_az
  source   = "./modules/eip"

  name = "nat-eip"
  az   = each.key
}

module "nat-gate" {
  depends_on = [module.nat-eip]
  for_each   = local.nat_config_by_az
  source     = "./modules/nat"

  pub_sub       = each.value.subnet_id
  allocation_id = each.value.eip_ip
  az            = each.key
  name          = var.name
}

module "public_route" {
  source = "./modules/route"

  vpc_id    = module.vpc.vpc_id
  igw_id    = module.igw.ids
  name      = var.name
  subnet_id = local.all_public_subnet_ids
  is_public = true
}

module "private_route" {
  for_each = local.nat_route_config_by_az
  source   = "./modules/route"

  vpc_id    = module.vpc.vpc_id
  nat_id    = each.value.nat_gateway.id
  name      = var.name
  az        = each.key
  subnet_id = each.value.subnet_ids
  is_public = false
}

