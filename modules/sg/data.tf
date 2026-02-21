data "aws_ssm_parameter" "vpc_id" {
  name = var.vpc_ssm_param_name
}

