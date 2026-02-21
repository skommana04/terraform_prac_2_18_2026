vpc_cidr_block = "10.0.0.0/16"
project = "roboshop"
env = "dev"
public_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
database_cidrs = ["10.0.21.0/24", "10.0.22.0/24"]
sg_names = ["mongodb", "redis", "rabbitmq", "mysql", "catalogue", "user", "cart", "shipping", "payment", "frontend", "bastion", "frontend-alb", "backend-alb"]