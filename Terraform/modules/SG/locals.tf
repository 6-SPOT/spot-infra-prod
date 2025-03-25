# locals {
#   ingress_cidr_rules = {
#     for idx, rule in var.ingress :
#     "ingress-cidr-${idx}" => rule
#     if can(rule.cidr_blocks)
#   }

#   ingress_sg_rules = {
#     for idx, rule in var.ingress :
#     "ingress-sg-${idx}" => rule
#     if can(rule.security_groups)
#   }

#   egress_cidr_rules = {
#     for idx, rule in var.egress :
#     "egress-cidr-${idx}" => rule
#     if can(rule.cidr_blocks)
#   }

#   egress_sg_rules = {
#     for idx, rule in var.egress :
#     "egress-sg-${idx}" => rule
#     if can(rule.security_groups)
#   }
# }

locals {
  ingress_cidr_list = flatten([
    for idx, rule in var.ingress : [
      for cidr_idx, cidr in lookup(rule, "cidr_blocks", []) : {
        key         = "cidr-${idx}-${cidr_idx}"
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr        = cidr
        description = lookup(rule, "description", null)
      }
    ] if can(rule.cidr_blocks)
  ])
  ingress_cidr_rules = {
    for rule in local.ingress_cidr_list :
    rule.key => rule
  }


  ingress_sg_list = flatten([
    for idx, rule in var.ingress : [
      for sg_idx, sg in lookup(rule, "security_groups", []) : {
        key         = "sg-${idx}-${sg_idx}"
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        sg          = sg
        description = lookup(rule, "description", null)
      }
    ] if can(rule.security_groups)
  ])
  ingress_sg_rules = {
    for rule in local.ingress_sg_list :
    rule.key => rule
  }
  #---

  egress_cidr_list = flatten([
    for idx, rule in var.egress : [
      for cidr_idx, cidr in lookup(rule, "cidr_blocks", []) : {
        key         = "cidr-${idx}-${cidr_idx}"
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        cidr        = cidr
        description = lookup(rule, "description", null)
      }
    ] if can(rule.cidr_blocks)
  ])
  egress_cidr_rules = {
    for rule in local.egress_cidr_list :
    rule.key => rule
  }

  egress_sg_list = flatten([
    for idx, rule in var.egress : [
      for sg_idx, sg in lookup(rule, "security_groups", []) : {
        key         = "sg-${idx}-${sg_idx}"
        from_port   = rule.from_port
        to_port     = rule.to_port
        protocol    = rule.protocol
        sg          = sg
        description = lookup(rule, "description", null)
      }
    ] if can(rule.security_groups)
  ])
  egress_sg_rules = {
    for rule in local.egress_sg_list :
    rule.key => rule
  }
}
