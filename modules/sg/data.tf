data "aws_ssm_parameter" "vpc_id" {
  name = module.vpc_id.name
}