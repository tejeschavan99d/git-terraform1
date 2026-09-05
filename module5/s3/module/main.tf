resource "aws_s3_bucket" "s3" {
  bucket = "${var.bucketname}"
  region = "ap-south-1"
  force_destroy = true
  tags = {
    Name = "${var.env}-${var.app}-state-management"
  }
}