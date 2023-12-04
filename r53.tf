
# module "records" {
#   source    = "terraform-aws-modules/route53/aws//modules/records"
#   version   = "2.10.2"
#   zone_name = local.zone_name
#   #  zone_id = local.zone_id

#   records = [
#     {
#       name = "frtr"
#       type = "A"
#       ttl  = 3600
#       records = [
#         module.ec2_instance_vpn_gw_frr.public_ip,
#       ]
#   }]
# }