variable "vpc_name" {
  type        = string
  description = "vpc name"
  default = dev_vpc
}

variable "vpc_id" {
    type        = string
    description = "vpc id"
    default = 
}


variable "vpc_region" {
  type        = string
  default = "us-east-1"
  description = "vpc cidr block variable"
}

variable "vpc_cidr_block" {
  type        = list(string)
  description = "vpc cidr block variable"
  default = ""
}

variable "subnet_cidr_block" {
  type        = string
  description = "subnet cidr block variable"
}

variable "availability_zone" {
  type        = string
  description = "availability zone"
}

variable "environment" {
  type        = string
  description = "deployment environment"
}


