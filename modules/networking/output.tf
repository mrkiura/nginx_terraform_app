output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private_subnet: subnet.id]
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public_subnet: subnet.id]
}

output "default_sg_id" {
  value = aws_security_group.default.id
}

output "availability_zones" {
  value = [for subnet in aws_subnet.public_subnet: subnet.availability_zone]
}