resource "aws_key_pair" "key" {
  key_name   = "${var.env}-${var.app}-key"
  public_key = file(var.pub_file)
}