locals {
  az_count = length(data.aws_availability_zones.available.names)
}

locals {
  final_count =  var.max_az_count > local.az_count ? local.az_count : var.max_az_count
}

module "networking" {
  source              = "../modules/networking"
  environment         = var.environment
  vpc_cidr_block      = var.vpc_cidr_block
  availability_zones  = slice(data.aws_availability_zones.available.names, 0, local.final_count)
  # availability_zones  = data.aws_availability_zones.available.names
  ami_id              = data.aws_ami.ubuntu.id
  region              = var.region
  key_name            = var.key_name
  depends_on          = [aws_key_pair.key]
}

