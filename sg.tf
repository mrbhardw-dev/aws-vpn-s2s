module "security_group_transit" {
  source                   = "terraform-aws-modules/security-group/aws"
  version                  = "5.1.0"
  name                     = "${module.label.id}-transit-01"
  use_name_prefix          = false
  description              = "Security group which is used as an argument in complete-sg"
  vpc_id                   = module.transit.vpc_attributes.id
  ingress_cidr_blocks      = [var.aws_cidr_block, "37.228.201.96/32", "18.198.173.20/32"]
  ingress_ipv6_cidr_blocks = ["2a02:8086:c93:1580:eb15:2996:35b9:2364/128"]
  ingress_rules            = ["https-443-tcp", "ssh-tcp", "vault-tcp", "ipsec-500-udp", "ipsec-4500-udp", "all-all"]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_ipv6_cidr_blocks = [
    {
      rule             = "all-all"
      ipv6_cidr_blocks = "::/0"
    }
  ]
}

module "security_group_vpn" {
  source                   = "terraform-aws-modules/security-group/aws"
  version                  = "5.1.0"
  name                     = "${module.label.id}-vpn-01"
  use_name_prefix          = false
  description              = "Security group which is used as an argument in complete-sg"
  vpc_id                   = module.vpn.vpc_attributes.id
  ingress_cidr_blocks      = [var.aws_cidr_block, "37.228.201.96/32", "18.198.173.20/32", ]
  ingress_ipv6_cidr_blocks = ["2a02:8086:c93:1580:eb15:2996:35b9:2364/128"]
  ingress_rules            = ["https-443-tcp", "ssh-tcp", "vault-tcp", "ipsec-500-udp", "ipsec-4500-udp", "all-all"]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_ipv6_cidr_blocks = [
    {
      rule             = "all-all"
      ipv6_cidr_blocks = "::/0"
    }
  ]
}