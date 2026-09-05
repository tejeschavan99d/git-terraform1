variable "env" {
  type = string
}
variable "app" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "ingress" {
  type = list(object({
    from_port = number
    to_port = number
    cidr_blocks = list(string)
    description = string
    protocol = string
  }))
}
variable "egress" {
  type = list(object({
    from_port = number
    to_port = number
    cidr_blocks = list(string)
    description = string
    protocol = string
  }))
}