################################################################################
# Security Group
################################################################################

resource "aws_security_group" "main" {
  name                   = var.name
  name_prefix            = var.name_prefix
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  tags = merge(
    var.tags,
    {
      Name = coalesce(var.name, var.name_prefix)
    }
  )
}

################################################################################
# Ingress Rules
################################################################################

resource "aws_vpc_security_group_ingress_rule" "main" {
  for_each = local.ingress_rules

  security_group_id = aws_security_group.main.id
  description       = each.value.description

  # Source configuration - one of these must be set
  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id

  # Port configuration
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.ip_protocol

  tags = merge(
    var.tags,
    each.value.tags,
    {
      Name = "${coalesce(var.name, var.name_prefix)}-ingress-${each.key}"
    }
  )
}

################################################################################
# Egress Rules
################################################################################

resource "aws_vpc_security_group_egress_rule" "main" {
  for_each = local.egress_rules

  security_group_id = aws_security_group.main.id
  description       = each.value.description

  # Destination configuration - one of these must be set
  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id

  # Port configuration
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.ip_protocol

  tags = merge(
    var.tags,
    each.value.tags,
    {
      Name = "${coalesce(var.name, var.name_prefix)}-egress-${each.key}"
    }
  )
}
