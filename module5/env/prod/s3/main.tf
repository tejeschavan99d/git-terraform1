terraform {
  backend "s3" {
    bucket = "tejesapacs3statemanagemnt"
    key    = "prod/s3/terraform.tfstate"
    region = "ap-south-1"
  }
}

module "s3" {
  source = "../../../../module5/s3/module"
  bucketname = "tejesapacs3statemanagemnt"
  env = "prod"
  app = "web"
}