module "vpc" {
  source = "./modules/networking"
  cidr   = var.vpc_cidr_block
}