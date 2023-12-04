
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket         = "asrock-tf-state-eu-west-1"
    key            = "aws-s2s/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "asrock-tf-state-eu-west-1"
  }
}