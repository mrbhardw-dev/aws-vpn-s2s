resource "aws_ec2_transit_gateway" "example" {
  description = "example"
  tags = {
    Name = "euw1-${module.label.id}-transit-01"
  }
}
