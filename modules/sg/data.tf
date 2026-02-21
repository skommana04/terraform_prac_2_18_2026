data "aws_ssm_parameter" "vpc_id" {
  name = var.vpc_ssm_param_name
}

data "aws_ssm_parameter" "frontend_sg_id" {
  name = "/${var.project}/${var.env}/frontend_sg_id"
}

data "aws_ssm_parameter" "frontend-alb_sg_id" {
  name = "/${var.project}/${var.env}/frontend-alb_sg_id"
}