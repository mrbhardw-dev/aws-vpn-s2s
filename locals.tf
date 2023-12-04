locals {
  egress_vpc_cidr           = cidrsubnet(var.aws_cidr_block, 4, 1)
  ingress_vpc_cidr          = cidrsubnet(var.aws_cidr_block, 4, 0)
  transit_public_subnet_ids = [for _, value in module.transit.public_subnet_attributes_by_az : value.id]
  vpn_public_subnet_ids     = [for _, value in module.vpn.public_subnet_attributes_by_az : value.id]
  vpn_private_subnet_ids    = [for _, value in module.vpn.private_subnet_attributes_by_az : value.id]
  # tgw_subnet_ids            = [for _, value in module.transit.tgw_subnet_attributes_by_az : value.id]
  vpn_private_to_eni = { for k, v in module.vpn.rt_attributes_by_type_by_az.private : k => v.id }
  zone_name          = "mrbhardw.awsps.myinstance.com"
  user_data = templatefile("${path.module}/onboarding.tftpl",
    {
      primary_tunnel_ip       = module.vpn_gateway.vpn_connection_tunnel1_address,
      secondary_tunnel_ip     = module.vpn_gateway.vpn_connection_tunnel2_address,
      primary_bgp_neighbour   = module.vpn_gateway.vpn_connection_tunnel1_vgw_inside_address,
      secondary_bgp_neighbour = module.vpn_gateway.vpn_connection_tunnel2_vgw_inside_address,
      local_as                = "64520"
      remote_as               = "64512"
      router_id               = aws_eip.eip.public_ip
      bgp_advertised_network  = local.ingress_vpc_cidr
  })
}
