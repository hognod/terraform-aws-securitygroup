locals {
  ################################################################################
  # All Rules
  ################################################################################

  all_rules = {
    for idx, name in var.rule_names : name => {
      type                         = var.rule_types[idx]
      description                  = length(var.rule_descriptions) > idx ? var.rule_descriptions[idx] : null
      cidr_ipv4                    = length(var.rule_cidr_ipv4) > idx ? (var.rule_cidr_ipv4[idx] != "" ? var.rule_cidr_ipv4[idx] : null) : null
      cidr_ipv6                    = length(var.rule_cidr_ipv6) > idx ? (var.rule_cidr_ipv6[idx] != "" ? var.rule_cidr_ipv6[idx] : null) : null
      prefix_list_id               = length(var.rule_prefix_list_ids) > idx ? (var.rule_prefix_list_ids[idx] != "" ? var.rule_prefix_list_ids[idx] : null) : null
      referenced_security_group_id = length(var.rule_referenced_security_group_ids) > idx ? (var.rule_referenced_security_group_ids[idx] != "" ? var.rule_referenced_security_group_ids[idx] : null) : null
      from_port                    = length(var.rule_from_ports) > idx ? var.rule_from_ports[idx] : null
      to_port                      = length(var.rule_to_ports) > idx ? var.rule_to_ports[idx] : null
      ip_protocol                  = var.rule_ip_protocols[idx]
      tags                         = lookup(var.rule_tags, name, {})
    }
  }

  ################################################################################
  # Ingress Rules (filtered from all_rules)
  ################################################################################

  ingress_rules = {
    for name, rule in local.all_rules : name => rule if rule.type == "ingress"
  }

  ################################################################################
  # Egress Rules (filtered from all_rules)
  ################################################################################

  egress_rules = {
    for name, rule in local.all_rules : name => rule if rule.type == "egress"
  }
}
