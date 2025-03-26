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

module "default_listener_rule" {
  # for_each = var.listener_rule_config
  for_each = local.listener_rule_config_with_tg
  source   = "./modules/alb_listener_rule"

  listener_arn = module.external_alb[(keys(module.external_alb))[0]].https_listener_arn
  priority     = each.value.priority
  actions      = each.value.actions
  conditions   = each.value.conditions
}

module "ec2_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  role_name               = "${var.name}-ec2-profbile"
  create_role             = true
  create_instance_profile = true
  trusted_role_services   = ["ec2.amazonaws.com"]
  role_requires_mfa       = false

  custom_role_policy_arns = var.ec2_profile

  number_of_custom_role_policy_arns = 4
}

module "codedeploy_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  trusted_role_services   = ["codedeploy.amazonaws.com"]
  role_name               = "${var.name}-codedeploy-role"
  create_role             = true
  custom_role_policy_arns = var.codedeploy_role
  role_requires_mfa       = false

  number_of_custom_role_policy_arns = 1
}

module "launch_template_create" {
  for_each = var.launch_template_config
  source   = "./modules/launch_template"

  server_type     = each.key
  instance_type   = each.value.instance_type
  name            = var.name
  git_repo_url    = each.value.git_repo_url
  ami_id          = each.value.ami_id
  security_groups = values(local.sg_list[each.key])
  key_name        = each.value.key_name
  ec2_profile     = module.ec2_role.iam_role_name
}

module "asg" {
  for_each = local.asg_config_merge
  source   = "./modules/auto_scaling"

  server                  = each.key
  name                    = var.name
  subnets                 = each.value.subnets
  min_size                = each.value.min_size
  max_size                = each.value.max_size
  desired_capacity        = each.value.desired_capacity
  launch_template_version = each.value.launch_template_version
  launch_template_id      = each.value.launch_template_id
  target_group_arns       = each.value.target_group_arns
}

module "codeDeploy" {
  for_each = local.codeDeploy_config_merge
  source   = "./modules/code_deploy"

  name              = var.name
  server_type       = each.key
  role_arn          = module.codedeploy_role.iam_role_arn
  target_group_name = each.value.target_group_name
}
