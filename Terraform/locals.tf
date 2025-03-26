locals {
  public_subnet_ids_by_az = {
    for az in distinct([for _, m in module.public_sub : m.az]) :
    az => [for _, m in module.public_sub : m.subnet_id if m.az == az]
  }

  public_alb_subnets = [for _, list in local.public_subnet_ids_by_az : list[0]]

  priavte_subnet_ids_by_az = {
    for az in distinct([for _, m in module.private_sub : m.az]) :
    az => [for _, m in module.private_sub : m.subnet_id if m.az == az]
  }

  private_alb_subnets = [for _, list in local.priavte_subnet_ids_by_az : list[0]]

  nat_eip_ids_by_az = {
    for az, mod in module.nat-eip :
    az => mod.eip-allocation_id
  }

  nat_config_by_az = {
    for az in keys(local.public_subnet_ids_by_az) :
    az => {
      subnet_id = local.public_subnet_ids_by_az[az][0]
      eip_ip    = local.nat_eip_ids_by_az[az]
    }
  }

  nat_info_by_az = {
    for az, mod in module.nat-gate :
    az => mod.nat_info
  }

  all_public_subnet_ids = flatten([
    for az_subnets in local.public_subnet_ids_by_az : az_subnets
  ])

  all_private_subnet_ids = flatten([
    for az_subnets in local.priavte_subnet_ids_by_az : az_subnets
  ])

  nat_route_config_by_az = {
    for az in keys(local.nat_info_by_az) :
    az => {
      nat_gateway = local.nat_info_by_az[az]
      subnet_ids  = local.priavte_subnet_ids_by_az[az]
    }
  }
  sg_list = {
    for k, mod in module.sg :
    k => {
      id = mod.security_group_id
    }
  }

  tg_arns = {
    for key, mod in module.tg :
    key => mod.tg_arn
  }
  
  tg_names = {
    for k, mod in module.tg :
    k => mod.tg_name
  }

  listener_rule_config_with_tg = {
    for k, v in var.listener_rule_config :
    k => merge(v, {
      actions = merge(v.actions, {
        target_group_arn = lookup(local.tg_arns, k)
      })
    })
  }

  launch_template_list = {
    for k, mod in module.launch_template_create :
    k => mod.arn
  }

  asg_config_merge = {
    for k, v in var.asg_config :
    k => merge(v, {
      launch_template_id      = module.launch_template_create[k].id
      launch_template_version = module.launch_template_create[k].latest_version
      target_group_arns       = [local.tg_arns[k]]
      subnets                 = [for _, m in module.private_sub : m.subnet_id]

    })
  }

  codeDeploy_config_merge = {
    for k, v in var.codeDeploy_config :
    k => merge(v, {
      target_group_name = local.tg_names[k]
    })
  }
}



