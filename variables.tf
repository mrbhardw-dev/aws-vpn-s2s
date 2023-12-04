variable "aws_cidr_block" {
  type    = string
  default = "100.64.0.0/16"
}

variable "region" {
  type    = string
  default = "eu-west-1"

}

variable "namespace" {
  type        = string
  description = "namespace, which could be your organization name, e.g. amazon"
  default     = "iac"
}

variable "env" {
  type        = string
  description = "environment, e.g. 'sit', 'uat', 'prod' etc"
  default     = "prod"
}

variable "project" {
  type        = string
  description = "environment, e.g. 'sit', 'uat', 'prod' etc"
  default     = "aws"
}

variable "account" {
  type        = string
  description = "account, which could be AWS Account Name or Number"
  default     = ""
}

variable "name" {
  type        = string
  description = "stack name"
  default     = ""
}
variable "ami" {
  type    = string
  default = "ami-03bfa38565aee6fb0"

}

variable "instance_type" {
  type    = string
  default = "t3.xlarge"

}

# variable "primary_tunnel_ip" {
#   description = "Default timezone for EC2 instances"
#   type = string
#   default     = module.vpn_gateway.primary_tunnel_ip
# }
