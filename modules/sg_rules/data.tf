data "aws_ssm_parameter" "frontend_sg_id" {
  name = "/${var.project}/${var.env}/frontend_sg_id"
}

data "aws_ssm_parameter" "frontend-alb_sg_id" {
  name = "/${var.project}/${var.env}/frontend-alb_sg_id"
}

data "aws_ssm_parameter" "backend-alb_sg_id" {
  name = "/${var.project}/${var.env}/backend-alb_sg_id"
}

data "aws_ssm_parameter" "backend_sg_id" {
  name = "/${var.project}/${var.env}/backend_sg_id"
}

data "aws_ssm_parameter" "bastion_sg_id" {
  name = "/${var.project}/${var.env}/bastion_sg_id"
}