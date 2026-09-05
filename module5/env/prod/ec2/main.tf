terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "tejesapacs3statemanagemnt"
    key    = "prod/ec2/terraform.tfstate"
    region = "ap-south-1"
  }
}
provider "aws" {
  region = "ap-south-1"
}
# data "terraform_remote_state" "sg" {
#   backend = "local"

#   config = {
#     path = "../sg/terraform.tfstate"
#   }
# }
data "terraform_remote_state" "sg" {
  backend = "s3"

  config = {
    bucket = "tejesapacs3statemanagemnt"
    key    = "prod/sg/terraform.tfstate"
    region = "ap-south-1"
  }
}

# data "terraform_remote_state" "key_name" {
#   backend = "local"

#   config = {
#     path = "../key_pair/terraform.tfstate"
#   }
# }

data "terraform_remote_state" "key_name" {
  backend = "s3"
  config = {
    bucket = "tejesapacs3statemanagemnt"
    key    = "prod/key_pair/terraform.tfstate"
    region = "ap-south-1"
  }
}

# data "terraform_remote_state" "vpc" {
#   backend = "local"

#   config = {
#     path = "../vpc/terraform.tfstate"
#   }
# }

data "terraform_remote_state" "vpc" {
  backend = "s3"
  
  config = {
    bucket = "tejesapacs3statemanagemnt"
    key    = "prod/vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}

module "ec2" {
  source = "../../../../module5/ec2/module"
  ami = "ami-01a00762f46d584a1"
  instance_type = "m7i-flex.large"
  public_subnet_id = values(data.terraform_remote_state.vpc.outputs.subnets.public_subnet_id)[0]
  # data.terraform_remote_state.vpc.outputs.vpc_details.subnets.public_subnet_id
  # data.terraform_remote_state.vpc.outputs.vpc_details.public_subnet_id
  key_name = data.terraform_remote_state.key_name.outputs.key_name
  sgid = data.terraform_remote_state.sg.outputs.sg_details
  volume_size = 8
  volume_type = "gp3"
  env = "prod"
  app = "web"
}