data "aws_ami" "latest_ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical account ID
}

# data "template_file" "cloud_init" {
#   template = file("${path.module}/ONBOARD_EC2.tftpl")
#   vars = {
#     TimeZone             = var.timezone
#     AuthorizedUserName   = "ubuntu"
#     AuthorizedUserSSHKey = ""
#   }
# }