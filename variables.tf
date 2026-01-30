################################################################################
# Security Group
################################################################################

variable "name" {
  description = <<-EOF
    Name of the security group. If omitted, use name_prefix instead.
    Example: "web-sg"
  EOF
  type        = string
  default     = null
}

variable "name_prefix" {
  description = <<-EOF
    Creates a unique name beginning with the specified prefix. Conflicts with name.
    Example: "web-sg-"
  EOF
  type        = string
  default     = null
}

variable "description" {
  description = <<-EOF
    Description of the security group.
    Example: "Security group for web servers"
  EOF
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = <<-EOF
    VPC ID to create the security group in.
    Example: "vpc-0123456789abcdef0"
  EOF
  type        = string
}

variable "revoke_rules_on_delete" {
  description = <<-EOF
    Instruct Terraform to revoke all security group rules before deleting the security group itself.
    Example: false
  EOF
  type        = bool
  default     = false
}

################################################################################
# Security Group Rules
################################################################################

variable "rule_names" {
  description = <<-EOF
    List of rule names. Used as identifiers for each rule.
    Example: ["http", "https", "ssh", "all-outbound"]
  EOF
  type        = list(string)
  default     = []
}

variable "rule_types" {
  description = <<-EOF
    List of rule types. Must be either "ingress" or "egress". Must match the order of rule_names.
    Example: ["ingress", "ingress", "ingress", "egress"]
  EOF
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for type in var.rule_types : contains(["ingress", "egress"], type)
    ])
    error_message = "Each rule_type must be either 'ingress' or 'egress'."
  }
}

variable "rule_descriptions" {
  description = <<-EOF
    List of descriptions for rules. Must match the order of rule_names.
    Example: ["Allow HTTP traffic", "Allow HTTPS traffic", "Allow SSH from bastion", "Allow all outbound"]
  EOF
  type        = list(string)
  default     = []
}

variable "rule_cidr_ipv4" {
  description = <<-EOF
    List of IPv4 CIDR blocks for rules.
    Example: ["0.0.0.0/0", "0.0.0.0/0", "10.0.0.0/16", "0.0.0.0/0"]
  EOF
  type        = list(string)
  default     = []
}

variable "rule_cidr_ipv6" {
  description = <<-EOF
    List of IPv6 CIDR blocks for rules.
    Example: ["::/0", "", "", ""]
  EOF
  type        = list(string)
  default     = []
}

variable "rule_prefix_list_ids" {
  description = <<-EOF
    List of prefix list IDs for rules.
    Example: ["pl-0123456789abcdef0", "", "", ""]
  EOF
  type        = list(string)
  default     = []
}

variable "rule_referenced_security_group_ids" {
  description = <<-EOF
    List of referenced security group IDs for rules.
    Example: ["", "", "sg-0123456789abcdef0", ""]
  EOF
  type        = list(string)
  default     = []
}

variable "rule_from_ports" {
  description = <<-EOF
    List of start port numbers for rules. Use -1 for all ports.
    Example: [80, 443, 22, -1]
  EOF
  type        = list(number)
  default     = []
}

variable "rule_to_ports" {
  description = <<-EOF
    List of end port numbers for rules. Use -1 for all ports.
    Example: [80, 443, 22, -1]
  EOF
  type        = list(number)
  default     = []
}

variable "rule_ip_protocols" {
  description = <<-EOF
    List of IP protocols for rules. Valid values: tcp, udp, icmp, icmpv6, or protocol number.
    Use "-1" for all protocols.
    Example: ["tcp", "tcp", "tcp", "-1"]
  EOF
  type        = list(string)
  default     = []
}

variable "rule_tags" {
  description = <<-EOF
    Map of rule names to additional tags.
    Example: {
      "http"  = { Service = "web" }
      "https" = { Service = "web" }
      "ssh"   = { Service = "admin" }
    }
  EOF
  type        = map(map(string))
  default     = {}
}

################################################################################
# Common
################################################################################

variable "tags" {
  description = <<-EOF
    Tags to apply to all resources.
    Example: {
      Environment = "dev"
      Project     = "my-project"
      ManagedBy   = "terraform"
    }
  EOF
  type        = map(string)
  default     = {}
}
