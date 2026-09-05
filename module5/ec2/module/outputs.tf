output "ec2_details" {
  value = aws_instance.ec2.public_ip
}