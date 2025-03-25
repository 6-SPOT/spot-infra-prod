module "vpc" {
  source     = "./modules/vpc"
  cidr_block = var.vpc_cidr
  name       = var.name
}

module "SSL_cert" {
  source            = "./modules/amc"
  domain            = var.domain
  validation_method = var.validation_method
  zone_id           = var.route53_zone_id
  sub_domain        = var.sub_domain
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

module "sg" {
  for_each = var.sg_config
  source   = "./modules/sg"

  vpc_id  = module.vpc.vpc_id
  sg_name = each.key
  name    = var.name
  ingress = each.value.ingress
  egress  = each.value.egress
}

module "tg" {
  for_each = var.tg_config
  source   = "./modules/tg"

  name        = var.name
  vpc_id      = module.vpc.vpc_id
  key         = each.key
  port        = each.value.port
  protocol    = each.value.protocol
  type        = each.value.type
  health_path = each.value.health_path
}

module "s3_for_alb_logs" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.name}-for-logs"

  force_destroy = true

  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  attach_elb_log_delivery_policy = true
  attach_lb_log_delivery_policy  = true
}

module "external_alb" {
  for_each = var.alb_config
  source   = "./modules/alb"

  is_internal     = each.value.is_internal
  type            = each.value.type
  subnets         = flatten(values(local.public_subnet_ids_by_az))
  name            = var.name
  security_groups = [local.sg_list["fe"].id]
  enable_https    = each.value.enable_https
  enable_logging  = each.value.enable_logging
  logging         = each.value.logging
  bucket          = module.s3_for_alb_logs.s3_bucket_id
  certificate_arn = module.SSL_cert.certificate_arn
}

# 기존 domain에 임의로 연결
resource "aws_route53_record" "alb" {
  zone_id = var.route53_zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = module.external_alb[(keys(module.external_alb))[0]].alb_dns_name
    zone_id                = module.external_alb[(keys(module.external_alb))[0]].alb_zone_id
    evaluate_target_health = true
  }
}
