variable "env" {
  type = string
}
variable "app" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "public_cidr" {
  type = list(string)
}
variable "private_cidr" {
  type = list(string)
}