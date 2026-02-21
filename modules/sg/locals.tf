locals {
    full_sg_name = "${var.project}-${var.env}-${var.sg_name}"
    vpc_id = data.aws_ssm_parameter.vpc_id.value

}