data "aws_ssm_parameter" "backend-alb_sg_id" {
  name = "/${var.project}/${var.env}/backend-alb_sg_id"
}
data "aws_ssm_parameter" "public_subnet_ids" {
    name = "/${var.project}/${var.env}/public_subnet_ids"
}

data "aws_ssm_parameter" "private_subnet_ids" {
    name = "/${var.project}/${var.env}/private_subnet_ids"
}