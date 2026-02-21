module "vpc" {
  source = "./modules/networking"
  cidr   = var.vpc_cidr_block
  project =  var.project
  env = var.env
  public_cidrs = var.public_cidrs
  private_cidrs = var.private_cidrs
  database_cidrs = var.database_cidrs
}

module "sg" {
    source = "./modules/sg"
    count = length(var.sg_names)
    #for_each = toset(var.sg_names)
    #sg_name = each.key
    sg_name = var.sg_names[count.index]
    project =  var.project
    env = var.env    
    vpc_ssm_param_name = "${var.project}-${var.env}-vpc_id"
    depends_on = [ module.vpc ]
}

module "ec2" {
    source = "./modules/ec2"
    project =  var.project
    env = var.env  
    depends_on = [module.sg]
    
}

module "sg_rules" {
    source = "./modules/sg_rules"
    count = length(var.sg_names)
    sg_name = var.sg_names[count.index]
    project =  var.project
    env = var.env  
    frontend_sg_id = module.sg[9].sg_id
    frontend-alb_sg_id = module.sg[11].sg_id
    backend-alb_sg_id = module.sg[12].sg_id
    bastion_sg_id = module.sg[10].sg_id 
    depends_on = [ module.ec2 ]
    
}