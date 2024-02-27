variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable my_ip {}
variable instance_type {}
variable public_key_location {}



resource "aws_vpc" "appVPC" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "publicSubnet_AZ1" {
  vpc_id = aws_vpc.appVPC.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
      Name: "${var.env_prefix}-publicSubnet-AZ1"
  }
}

resource "aws_internet_gateway" "appVPC-IGW" {
  vpc_id = aws_vpc.appVPC.id

   tags = {
    Name = "${var.env_prefix}-IGW"
  }
}

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.appVPC.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.appVPC-IGW.id
  }


  tags = {
    Name = "${var.env_prefix}-mainRT"
  }
}

resource "aws_security_group" "app-SG" {
  name        = "app-SG"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.appVPC.id

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [var.my_ip]
  }

  ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      prefix_list_ids = []
  }


  tags = {
    Name = "${var.env_prefix}-appSG"
  }
}

data "aws_ami" "latest-amazon-linux-ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-ami.id
}

output "ec2_public_ip" {
  value = aws_instance.appServer.public_ip
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "server-key"
  public_key = file(var.public_key_location)
}


resource "aws_instance" "appServer" {
  ami           = data.aws_ami.latest-amazon-linux-ami.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.publicSubnet_AZ1.id
  vpc_security_group_ids = [aws_security_group.app-SG.id]
  availability_zone = var.avail_zone

  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name

  user_data = file("entry-script.sh")

  tags = {
    Name = "${var.env_prefix}-appServer"
  }
}




