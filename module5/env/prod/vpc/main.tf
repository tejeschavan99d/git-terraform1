terraform {
  backend "s3" {
    bucket = "tejesapacs3statemanagemnt"
    key    = "prod/vpc/terraform.tfstate"
    region = "ap-south-1"
  }
}

module "vpc" {
  source = "../../../../module5/vpc/module"
  env = "prod"
  app = "web"
  vpc_cidr = "10.0.0.0/16"
  public_cidr = [ 
    "10.0.1.0/24",
    "10.0.2.0/24"
   ]
  private_cidr = [ 
   "10.0.11.0/24",
   "10.0.12.0/24"
   ]
}