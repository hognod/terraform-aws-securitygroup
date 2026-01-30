# terraform-aws-securitygroup

AWS Security Group을 생성하고 관리하는 Terraform 모듈입니다.

## 포함된 리소스

- Security Group
- Security Group Ingress Rules
- Security Group Egress Rules

## 사용법

### 기본 사용 예시

```hcl
module "web_security_group" {
  source = "git::http://gitlab.mas-cloud.io/terraform/terraform-aws-security-group.git"

  name        = "web-sg"
  description = "Security group for web servers"
  vpc_id      = "vpc-0123456789abcdef0"

  # Rules
  rule_names        = ["http", "https", "all-outbound"]
  rule_types        = ["ingress", "ingress", "egress"]
  rule_descriptions = ["Allow HTTP", "Allow HTTPS", "Allow all outbound"]
  rule_cidr_ipv4    = ["0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0"]
  rule_from_ports   = [80, 443, -1]
  rule_to_ports     = [80, 443, -1]
  rule_ip_protocols = ["tcp", "tcp", "-1"]

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

### Security Group 간 참조 예시

```hcl
module "app_security_group" {
  source = "git::http://gitlab.mas-cloud.io/terraform/terraform-aws-security-group.git"

  name        = "app-sg"
  description = "Security group for application servers"
  vpc_id      = "vpc-0123456789abcdef0"

  # ... (VPC, Subnet, Route Table 설정)

  # Rules (다른 Security Group 참조)
  rule_names                        = ["alb", "ssh", "mysql", "all-outbound"]
  rule_types                        = ["ingress", "ingress", "ingress", "egress"]
  rule_descriptions                 = ["Allow from ALB", "Allow SSH from bastion", "Allow MySQL from app", "Allow all outbound"]
  rule_cidr_ipv4                    = ["", "", "", "0.0.0.0/0"]
  rule_referenced_security_group_ids = ["sg-alb123456", "sg-bastion123", "sg-app123456", ""]
  rule_from_ports                   = [8080, 22, 3306, -1]
  rule_to_ports                     = [8080, 22, 3306, -1]
  rule_ip_protocols                 = ["tcp", "tcp", "tcp", "-1"]

  tags = {
    Environment = "production"
    Application = "backend"
    ManagedBy   = "terraform"
  }
}
```

### IPv6 설정 예시

```hcl
module "ipv6_security_group" {
  source = "git::http://gitlab.mas-cloud.io/terraform/terraform-aws-security-group.git"

  name        = "ipv6-sg"
  description = "Security group with IPv6 support"
  vpc_id      = "vpc-0123456789abcdef0"

  # ... (VPC, Subnet, Route Table 설정)

  # Rules (IPv4 + IPv6)
  rule_names        = ["http-ipv4", "http-ipv6", "https-ipv4", "https-ipv6", "all-ipv4", "all-ipv6"]
  rule_types        = ["ingress", "ingress", "ingress", "ingress", "egress", "egress"]
  rule_descriptions = ["Allow HTTP IPv4", "Allow HTTP IPv6", "Allow HTTPS IPv4", "Allow HTTPS IPv6", "Allow all IPv4 outbound", "Allow all IPv6 outbound"]
  rule_cidr_ipv4    = ["0.0.0.0/0", "", "0.0.0.0/0", "", "0.0.0.0/0", ""]
  rule_cidr_ipv6    = ["", "::/0", "", "::/0", "", "::/0"]
  rule_from_ports   = [80, 80, 443, 443, -1, -1]
  rule_to_ports     = [80, 80, 443, 443, -1, -1]
  rule_ip_protocols = ["tcp", "tcp", "tcp", "tcp", "-1", "-1"]

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

### Prefix List 설정 예시

```hcl
module "prefix_list_security_group" {
  source = "git::http://gitlab.mas-cloud.io/terraform/terraform-aws-security-group.git"

  name        = "prefix-list-sg"
  description = "Security group using prefix lists"
  vpc_id      = "vpc-0123456789abcdef0"

  # ... (VPC, Subnet, Route Table 설정)

  # Rules (Prefix List 사용)
  rule_names            = ["s3-https-in", "s3-https-out"]
  rule_types            = ["ingress", "egress"]
  rule_descriptions     = ["Allow HTTPS from S3", "Allow HTTPS to S3"]
  rule_prefix_list_ids  = ["pl-0123456789abcdef0", "pl-0123456789abcdef0"]
  rule_from_ports       = [443, 443]
  rule_to_ports         = [443, 443]
  rule_ip_protocols     = ["tcp", "tcp"]

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Inputs

### Security Group

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Security Group 이름 | `string` | `null` | no |
| name_prefix | Security Group 이름 접두사 (name과 충돌) | `string` | `null` | no |
| description | Security Group 설명 | `string` | `"Managed by Terraform"` | no |
| vpc_id | VPC ID | `string` | - | yes |
| revoke_rules_on_delete | 삭제 시 모든 규칙 먼저 제거 여부 | `bool` | `false` | no |

### Security Group Rules

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| rule_names | 규칙 이름 목록 | `list(string)` | `[]` | no |
| rule_types | 규칙 타입 목록 ("ingress" 또는 "egress") | `list(string)` | `[]` | no |
| rule_descriptions | 규칙 설명 목록 | `list(string)` | `[]` | no |
| rule_cidr_ipv4 | IPv4 CIDR 블록 목록 | `list(string)` | `[]` | no |
| rule_cidr_ipv6 | IPv6 CIDR 블록 목록 | `list(string)` | `[]` | no |
| rule_prefix_list_ids | Prefix List ID 목록 | `list(string)` | `[]` | no |
| rule_referenced_security_group_ids | 참조 Security Group ID 목록 | `list(string)` | `[]` | no |
| rule_from_ports | 시작 포트 번호 목록 (-1: 모든 포트) | `list(number)` | `[]` | no |
| rule_to_ports | 종료 포트 번호 목록 (-1: 모든 포트) | `list(number)` | `[]` | no |
| rule_ip_protocols | IP 프로토콜 목록 (tcp, udp, icmp, icmpv6, -1) | `list(string)` | `[]` | no |
| rule_tags | 규칙별 추가 태그 | `map(map(string))` | `{}` | no |

### Common

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| tags | 모든 리소스에 적용할 태그 | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| security_group_id | Security Group ID |
| security_group_arn | Security Group ARN |
| security_group_name | Security Group 이름 |
| security_group_vpc_id | Security Group VPC ID |
| security_group_owner_id | Security Group 소유자 ID |
| ingress_rule_ids | Ingress 규칙 이름별 ID 맵 |
| ingress_rule_arns | Ingress 규칙 이름별 ARN 맵 |
| egress_rule_ids | Egress 규칙 이름별 ID 맵 |
| egress_rule_arns | Egress 규칙 이름별 ARN 맵 |

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 5.0.0 |
