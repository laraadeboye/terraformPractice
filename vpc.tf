resource "aws_vpc" "appVPC" {
  cidr_block       = var.cidr_blocks[0]
  instance_tenancy = "default"

  tags = {
    Name: var.environment
  }
}

resource "aws_subnet" "publicSubnet_AZ1" {
    vpc_id = aws_vpc.appVPC.id
    cidr_block = var.cidr_blocks[1]
    availability_zone = var.availability_zone
}



data "aws_vpc" "selected" {
  id = aws_vpc.appVPC.id
}

resource "aws_subnet" "publicSubnet_AZ2" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = "us-east-2a"
  cidr_block        = cidrsubnet(data.aws_vpc.selected.cidr_block, 4, 1)
}

output "app-vpc_id" {
    value = aws_vpc.appVPC.id
  
}

output "app-vpc_id" {
    value = aws_subnet.publicSubnet_AZ1.id
}