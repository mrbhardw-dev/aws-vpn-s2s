module "ec2_instance_transit_behind_vpn" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "5.1.0"
  name                        = "${module.label.id}-transit-ec2-01"
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = element(local.transit_public_subnet_ids, 0)
  vpc_security_group_ids      = [module.security_group_transit.security_group_id]
  tags                        = module.label.tags_aws
}

module "ec2_instance_behind_frr" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "5.1.0"
  name                        = "${module.label.id}-vpn-op-ec2-01"
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = false
  subnet_id                   = element(local.vpn_private_subnet_ids, 0)
  vpc_security_group_ids      = [module.security_group_vpn.security_group_id]
  tags                        = module.label.tags_aws
}

resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# # Create the Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = "key_pair"
  public_key = tls_private_key.key_pair.public_key_openssh
}

# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}

module "ec2_instance_vpn_gw_frr" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "5.1.0"
  name                        = "${module.label.id}-vpn-gw-frr-01"
  ami                         = data.aws_ami.latest_ubuntu.id
  instance_type               = var.instance_type
  source_dest_check           = false
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key_pair.key_name
  subnet_id                   = element(local.vpn_public_subnet_ids, 0)
  vpc_security_group_ids      = [module.security_group_vpn.security_group_id]
  user_data_base64            = base64encode(local.user_data)
  user_data_replace_on_change = true
  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  tags = module.label.tags_aws
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = module.ec2_instance_vpn_gw_frr.id
  allocation_id = aws_eip.eip.allocation_id
}

resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Name = "euw1-${module.label.id}-s2s-frr01"
  }
}