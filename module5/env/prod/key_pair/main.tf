terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "tejesapacs3statemanagemnt"
    key    = "prod/key_pair/terraform.tfstate"
    region = "ap-south-1"
  }
}
provider "aws" {
  region = "ap-south-1"
}
module "key_pair" {
  source   = "../../../../module5/key_pair/module"
  env      = "prod"
  app      = "web"
  pub_file = "${path.module}/terra-key-ec2.pub"
}
