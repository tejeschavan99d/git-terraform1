output "vpc_details" {
  value = {
    vpc_id = aws_vpc.vpc.id
  }
}
output "subnets" {
  value = {
    public_subnet_id = {
        for k, v in aws_subnet.public : k => v.id
    }
    private_subnet_id = {
        for k, v in aws_subnet.private : k => v.id
    }
  }
}

