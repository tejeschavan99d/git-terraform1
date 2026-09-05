resource "aws_security_group" "sg" {
  name = "${var.env}-${var.app}-SG"
  description = "${var.env}-${var.app}-SG"
  vpc_id = var.vpc_id
  
  dynamic "ingress" {
    for_each = var.ingress
    content {
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
      protocol = ingress.value.protocol
    }
  }
  dynamic "egress" {
    for_each = var.egress
    content {
      from_port = egress.value.from_port
      to_port = egress.value.to_port
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
      protocol = egress.value.protocol
    }
  }
  tags = {
    Name = "${var.env}-${var.app}-SG"
  }
}