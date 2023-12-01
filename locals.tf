locals {
  egress_vpc_cidr           = cidrsubnet(var.aws_cidr_block, 4, 1)
  ingress_vpc_cidr          = cidrsubnet(var.aws_cidr_block, 4, 0)
  transit_public_subnet_ids = [for _, value in module.transit.public_subnet_attributes_by_az : value.id]
  vpn_public_subnet_ids     = [for _, value in module.vpn.public_subnet_attributes_by_az : value.id]
  vpn_private_subnet_ids    = [for _, value in module.vpn.private_subnet_attributes_by_az : value.id]
  tgw_subnet_ids            = [for _, value in module.transit.tgw_subnet_attributes_by_az : value.id]
  vpn_private_to_eni        = { for k, v in module.vpn.rt_attributes_by_type_by_az.private : k => v.id }
}