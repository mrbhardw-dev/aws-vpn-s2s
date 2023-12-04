resource "aws_ec2_transit_gateway" "tgw_shared" {
  description = "euw1-${module.label.id}-transit-01"
  tags = {
    Name = "euw1-${module.label.id}-transit-01"
  }
}


module "transit" {
  source  = "aws-ia/vpc/aws"
  version = ">= 4.0.0"

  name               = "euw1-${module.label.id}-transit-01"
  cidr_block         = local.egress_vpc_cidr
  az_count           = 2
  transit_gateway_id = aws_ec2_transit_gateway.tgw_shared.id
  transit_gateway_routes = {
    public  = local.ingress_vpc_cidr
    private = local.ingress_vpc_cidr
  }

  subnets = {
    public = {
      name_prefix               = "sbt-trs-pub"
      netmask                   = 24
      nat_gateway_configuration = "all_azs"
    }
    private = {
      name_prefix             = "sbt-trs-pri"
      netmask                 = 24
      connect_to_public_natgw = true
    }
    transit_gateway = {
      netmask                                         = 28
      name_prefix                                     = "sbt-trs-tgw"
      connect_to_public_natgw                         = true
      transit_gateway_default_route_table_association = true
      transit_gateway_default_route_table_propagation = true
      transit_gateway_appliance_mode_support          = "disable"
      transit_gateway_dns_support                     = "disable"

      tags = {
        subnet_type = "tgw"
      }
    }
  }
}

module "vpn" {
  source  = "aws-ia/vpc/aws"
  version = ">= 4.0.0"

  name       = "euw1-${module.label.id}-vpn-01"
  cidr_block = local.ingress_vpc_cidr
  az_count   = 2

  subnets = {
    public = {
      name_prefix               = "sbt-vpn-pub"
      netmask                   = 24
      nat_gateway_configuration = "none"
    }

    private = {
      name_prefix             = "sbt-vpn-pri"
      netmask                 = 24
      connect_to_public_natgw = false
    }

  }
}