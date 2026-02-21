locals {
    sg_name = "${var.project}-${var.env}-sg"
    vpc_id = data.aws_ssm_parameter.vpc_id.value

}