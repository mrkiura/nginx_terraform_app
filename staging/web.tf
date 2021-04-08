
module "web" {
  source             = "../modules/web"
  depends_on         = [module.networking]
  region             = var.region
  instance_type      = "t2.micro"
  private_subnet_ids = module.networking.private_subnet_ids
  availability_zones = module.networking.availability_zones
  public_subnet_ids  = module.networking.public_subnet_ids
  vpc_sg_id          = module.networking.default_sg_id
  ami_id             = data.aws_ami.ubuntu.id
  key_name           = var.key_name
  environment        = var.environment
  vpc_id             = module.networking.vpc_id
  vpc_cidr_block     = var.vpc_cidr_block
}
