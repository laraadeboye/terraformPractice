
resource "aws_vpc" "appVPC" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

module "app-Subnet" {
  source = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.appVPC.id 
  vpc_cidr_block = var.vpc_cidr_block
  default_route_table_id = aws_vpc.appVPC.default_route_table_id
}

module "app-Server" {
source = "./modules/webserver"
vpc_cidr_block = var.vpc_cidr_block
subnet_cidr_block = var.subnet_cidr_block
avail_zone = var.avail_zone
env_prefix = var.env_prefix
vpc_id = aws_vpc.appVPC.id
my_ip = var.my_ip
subnet_id = module.app-Subnet.subnet.id
image_name = var.image_name
public_key_location = var.public_key_location
instance_type = var.instance_type

}





