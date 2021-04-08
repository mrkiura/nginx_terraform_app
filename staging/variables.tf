variable "environment" {
  default = "staging"
}

variable "max_az_count" {
  default = 2
}
variable "key_name" {
  description = "The aws keypair to use"
}

variable "region" {
  description = "Region that the instances will be created"
}

variable "aws_access_key" {
    description = "AWS API access key"
}

variable "aws_secret_key" {
    description = "AWS API secret_key"
}

# Networking
variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  default = "192.168.0.0/16"
}

variable "instance_type" {
  description = "The instance type to launch"
  default = "t2.micro"
}