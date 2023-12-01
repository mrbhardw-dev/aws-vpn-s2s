module "ec2_instance_transit" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "5.1.0"
  name                        = "${module.label.id}-transit-ec2"
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = element(local.transit_public_subnet_ids, 0)
  vpc_security_group_ids      = [module.security_group_transit.security_group_id]
  tags                        = module.label.tags_aws
}

module "ec2_instance_vpn" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "5.1.0"
  name                        = "${module.label.id}-vpnop-ec2"
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = false
  subnet_id                   = element(local.vpn_private_subnet_ids, 0)
  vpc_security_group_ids      = [module.security_group_vpn.security_group_id]
  tags                        = module.label.tags_aws
}

module "ec2_instance_vpngw" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "5.1.0"
  name                        = "${module.label.id}-vpngw-ec2"
  ami                         = "ami-069b9b78bba461319"
  instance_type               = var.instance_type
  source_dest_check           = false
  associate_public_ip_address = true
  subnet_id                   = element(local.vpn_public_subnet_ids, 0)
  vpc_security_group_ids      = [module.security_group_vpn.security_group_id]
  tags                        = module.label.tags_aws
}
