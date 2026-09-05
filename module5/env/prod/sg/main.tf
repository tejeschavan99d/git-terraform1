terraform {
  backend "s3" {
    bucket = "tejesapacs3statemanagemnt"
    key    = "prod/sg/terraform.tfstate"
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

module "sg" {
  source = "../../../../module5/sg/module/"
  env = "prod"
  app = "web"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_details.vpc_id
  ingress = [ {
    from_port = 22
    to_port = 22
    cidr_blocks = [ "0.0.0.0/0" ]
    protocol = "tcp"
    description = "allow ssh"
  },
  {
    from_port = 8080
    to_port = 8080
    cidr_blocks = [ "0.0.0.0/0" ]
    protocol = "tcp"
    description = "Jenkins"
  } ]
  egress = [ {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "outbound traffic"
  } ]
}