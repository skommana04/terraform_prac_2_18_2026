module "vpc" {
  source = "./modules/networking"
  cidr   = var.vpc_cidr_block
  project =  var.project
  env = var.env
  public_cidrs = var.public_cidrs
  private_cidrs = var.private_cidrs
  database_cidrs = var.database_cidrs
}