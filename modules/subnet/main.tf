resource "aws_subnet" "publicSubnet_AZ1" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
      Name: "${var.env_prefix}-publicSubnet-AZ1"
  }
}

resource "aws_internet_gateway" "appVPC-IGW" {
  vpc_id = var.vpc_id
   tags = {
    Name = "${var.env_prefix}-IGW"
  }
}

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = var.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.appVPC-IGW.id
  }


  tags = {
    Name = "${var.env_prefix}-mainRT"
  }
}