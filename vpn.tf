resource "aws_customer_gateway" "main" {
  bgp_asn    = 64520
  ip_address = aws_eip.eip.public_ip
  type       = "ipsec.1"

  tags = {
    Name = "euw1-${module.label.id}-s2s-frr01"
  }
}


module "vpn_gateway" {
  source  = "terraform-aws-modules/vpn-gateway/aws"
  version = "> 3.0"

  create_vpn_gateway_attachment        = true
  connect_to_transit_gateway           = true
  vpc_id                               = module.transit.vpc_attributes.id
  transit_gateway_id                   = aws_ec2_transit_gateway.tgw_shared.id
  customer_gateway_id                  = aws_customer_gateway.main.id
  tunnel1_inside_cidr                  = "169.254.44.88/30"
  tunnel2_inside_cidr                  = "169.254.44.100/30"
  tunnel1_preshared_key                = "1234567890abcdefghijklmn"
  tunnel2_preshared_key                = "1234567890abcdefghijklmn"
  tunnel1_ike_versions                 = ["ikev2"]
  tunnel1_phase1_dh_group_numbers      = [14]
  tunnel1_phase1_encryption_algorithms = ["AES256"]
  tunnel1_phase1_integrity_algorithms  = ["SHA2-256"]
  tunnel1_phase2_dh_group_numbers      = [14]
  tunnel1_phase2_encryption_algorithms = ["AES256"]
  tunnel1_phase2_integrity_algorithms  = ["SHA2-256"]
  tunnel2_ike_versions                 = ["ikev2"]
  tunnel2_phase1_dh_group_numbers      = [14]
  tunnel2_phase1_encryption_algorithms = ["AES256", ]
  tunnel2_phase1_integrity_algorithms  = ["SHA2-256"]
  tunnel2_phase2_dh_group_numbers      = [14]
  tunnel2_phase2_encryption_algorithms = ["AES256"]
  tunnel2_phase2_integrity_algorithms  = ["SHA2-256"]
  tags = {
    Name = "euw1-${module.label.id}-s2s-frr01"
  }
}


