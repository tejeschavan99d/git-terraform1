resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.env}-${var.app}"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.public_cidr)
  cidr_block = var.public_cidr[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-${var.app}-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.private_cidr)
  cidr_block = var.private_cidr[count.index]
  tags = {
    Name = "${var.env}-${var.app}-private-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-${var.app}-IGW"
  }
}

resource "aws_eip" "natgw" {
  count = length(var.public_cidr)
  domain = "vpc"
  tags = {
    Name = "${var.env}-${var.app}-NAT-EIP-${count.index + 1}"
  }
}

resource "aws_nat_gateway" "natgw" {
  count = length(var.public_cidr)
  allocation_id = aws_eip.natgw[count.index].id
  subnet_id = aws_subnet.public[count.index].id
  tags = {
    Name = "${var.env}-${var.app}-NAT-GW-${count.index + 1}"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.env}-${var.app}-public-rt"
  }
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.private_cidr)
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw[count.index].id
  }
  tags = {
    Name = "${var.env}-${var.app}-private-rt-${count.index + 1}"
  }
}
resource "aws_route_table_association" "public_rt_asso" {
  count = length(var.public_cidr)
  route_table_id = aws_route_table.public_rt.id
  subnet_id = aws_subnet.public[count.index].id
}

resource "aws_route_table_association" "private_rt_asso" {
  count = length(var.private_cidr)
  route_table_id = aws_route_table.private_rt[count.index].id
  subnet_id = aws_subnet.private[count.index].id
}