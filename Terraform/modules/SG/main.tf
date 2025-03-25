resource "aws_security_group" "this" {
  name   = "${var.name}-${var.sg_name}"
  vpc_id = var.vpc_id
  tags = {
    Name = var.name
  }
}

# resource "aws_security_group_rule" "in-this" {
#   count = length(var.ingress)

#   security_group_id = aws_security_group.this.id
#   type              = "ingress"
#   from_port         = var.ingress[count.index].from_port
#   to_port           = var.ingress[count.index].to_port
#   protocol          = var.ingress[count.index].protocol
#   cidr_blocks       = var.ingress[count.index].cidr_blocks
# }

# resource "aws_security_group_rule" "e-this" {
#   count = length(var.egress)

#   security_group_id = aws_security_group.this.id
#   type              = "egress"
#   from_port         = var.egress[count.index].from_port
#   to_port           = var.egress[count.index].to_port
#   protocol          = var.egress[count.index].protocol
#   cidr_blocks       = var.egress[count.index].cidr_blocks
# }

# resource "aws_security_group_rule" "ingress_cidr" {
#   for_each = local.ingress_cidr_rules

#   type              = "ingress"
#   from_port         = each.value.from_port
#   to_port           = each.value.to_port
#   protocol          = each.value.protocol
#   cidr_blocks       = each.value.cidr_blocks
#   description       = lookup(each.value, "description", null)
#   security_group_id = aws_security_group.this.id
# }

# resource "aws_security_group_rule" "ingress_sg" {
#   for_each = local.ingress_sg_rules

#   type                     = "ingress"
#   from_port                = each.value.from_port
#   to_port                  = each.value.to_port
#   protocol                 = each.value.protocol
#   source_security_group_id = each.value.security_groups
#   description              = lookup(each.value, "description", null)
#   security_group_id        = aws_security_group.this.id
# }

# resource "aws_security_group_rule" "egress_cidr" {
#   for_each = local.egress_cidr_rules

#   type              = "egress"
#   from_port         = each.value.from_port
#   to_port           = each.value.to_port
#   protocol          = each.value.protocol
#   cidr_blocks       = each.value.cidr_blocks
#   description       = lookup(each.value, "description", null)
#   security_group_id = aws_security_group.this.id
# }

# resource "aws_security_group_rule" "egress_sg" {
#   for_each = local.egress_sg_rules

#   type                     = "egress"
#   from_port                = each.value.from_port
#   to_port                  = each.value.to_port
#   protocol                 = each.value.protocol
#   source_security_group_id = each.value.security_groups
#   description              = lookup(each.value, "description", null)
#   security_group_id        = aws_security_group.this.id
# }

resource "aws_vpc_security_group_ingress_rule" "cidr" {
  for_each = local.ingress_cidr_rules

  security_group_id = aws_security_group.this.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr
  description       = lookup(each.value, "description", null)
}


resource "aws_vpc_security_group_ingress_rule" "sg" {
  for_each = local.ingress_sg_rules

  security_group_id            = aws_security_group.this.id
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.protocol
  referenced_security_group_id = each.value.sg
  description                  = lookup(each.value, "description", null)
}


resource "aws_vpc_security_group_egress_rule" "cidr" {
  for_each = local.egress_cidr_rules

  security_group_id = aws_security_group.this.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr
  description       = lookup(each.value, "description", null)
}

resource "aws_vpc_security_group_egress_rule" "sg" {
  for_each = local.egress_sg_rules

  security_group_id            = aws_security_group.this.id
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  ip_protocol                  = each.value.protocol
  referenced_security_group_id = each.value.sg
  description                  = lookup(each.value, "description", null)
}
