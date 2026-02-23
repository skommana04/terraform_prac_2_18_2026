data "aws_ami" "redhat" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["973714476881"] # Canonical
}

data "aws_ssm_parameter" "public_subnet_ids" {
    name = "/${var.project}/${var.env}/public_subnet_ids"
}
data "aws_ssm_parameter" "private_subnet_ids" {
    name = "/${var.project}/${var.env}/private_subnet_ids"
}
data "aws_ssm_parameter" "database_subnet_ids" {
    name = "/${var.project}/${var.env}/database_subnet_ids"
}

data "aws_ssm_parameter" "bastion_sg_id" {
  name = "/${var.project}/${var.env}/bastion_sg_id"
}
data "aws_ssm_parameter" "redis_sg_id" {
  name = "/${var.project}/${var.env}/redis_sg_id"
}
data "aws_ssm_parameter" "rabbitmq_sg_id" {
  name = "/${var.project}/${var.env}/rabbitmq_sg_id"
}
data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project}/${var.env}/mysql_sg_id"
}
data "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/${var.project}/${var.env}/mongodb_sg_id"
}

data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project}/${var.env}/catalogue_sg_id"
}