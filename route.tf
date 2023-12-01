resource "aws_route" "internal" {
  for_each               = local.vpn_private_to_eni
  route_table_id         = each.value
  destination_cidr_block = local.egress_vpc_cidr
  network_interface_id   = module.ec2_instance_vpngw.primary_network_interface_id

}

resource "aws_route" "external" {
  for_each               = local.vpn_private_to_eni
  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.ec2_instance_vpngw.primary_network_interface_id
}