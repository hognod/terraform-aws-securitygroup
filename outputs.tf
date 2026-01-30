################################################################################
# Security Group
################################################################################

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.main.id
}

output "security_group_arn" {
  description = "The ARN of the security group"
  value       = aws_security_group.main.arn
}

output "security_group_name" {
  description = "The name of the security group"
  value       = aws_security_group.main.name
}

output "security_group_vpc_id" {
  description = "The VPC ID of the security group"
  value       = aws_security_group.main.vpc_id
}

output "security_group_owner_id" {
  description = "The owner ID of the security group"
  value       = aws_security_group.main.owner_id
}

################################################################################
# Ingress Rules
################################################################################

output "ingress_rule_ids" {
  description = "Map of ingress rule names to security group rule IDs"
  value       = { for k, v in aws_vpc_security_group_ingress_rule.main : k => v.security_group_rule_id }
}

output "ingress_rule_arns" {
  description = "Map of ingress rule names to ARNs"
  value       = { for k, v in aws_vpc_security_group_ingress_rule.main : k => v.arn }
}

################################################################################
# Egress Rules
################################################################################

output "egress_rule_ids" {
  description = "Map of egress rule names to security group rule IDs"
  value       = { for k, v in aws_vpc_security_group_egress_rule.main : k => v.security_group_rule_id }
}

output "egress_rule_arns" {
  description = "Map of egress rule names to ARNs"
  value       = { for k, v in aws_vpc_security_group_egress_rule.main : k => v.arn }
}
