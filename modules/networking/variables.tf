variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
}

variable "max_az_count" {
  description = "The maximum number of alllowed availability zones"
  default = 2
}

variable "availability_zones" {
  description = "The availability zones available in a region"
}

variable "environment" {
  description = "The environment"
  default = "staging"
}

variable "region" {
  description = "The region to launch the bastion host"
}




variable "key_name" {
  description = "The public key for the bastion host"
}

variable "ami_id" {
  description = "The id of the AMI"
}