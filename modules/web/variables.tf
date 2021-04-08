variable "region" {
  description = "The region to launch the instances"
}

variable "max_az_count" {
  default = 2
}

variable "instance_type" {
  description = "The instance type to launch"
  default = "t2.micro"
}


variable "vpc_sg_id" {
  description = "The default security group from the vpc"
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  default = "192.168.0.0/16"
}

variable "key_name" {
  description = "The keypair to use on the instances"
}

variable "environment" {
  description = "The environment for the instance"
  default = "staging"
}

variable "vpc_id" {
  description = "The id of the vpc"
}

variable "private_subnet_ids" {
  description = "The list of private subnet ids"
}

variable "public_subnet_ids" {
  description = "The list of private subnet ids"
}

variable "ami_id" {
  description = "The id of the AMI"
}

variable "availability_zones" {
  description = "The availability zones available in a region"
}

