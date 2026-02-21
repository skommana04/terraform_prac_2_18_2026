resource "aws_security_group_rule" "frontend_frontend-lb" {
  count = var.sg_name == "frontend" ? 1 : 0
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = data.aws_ssm_parameter.frontend_sg_id.value
  source_security_group_id = data.aws_ssm_parameter.frontend-alb_sg_id.value
  #module.sg[9].sg_id
}
resource "aws_security_group_rule" "backend_lb-bastion" {
  count = var.sg_name == "backend-alb" ? 1 : 0
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = data.aws_ssm_parameter.backend-alb_sg_id.value
  source_security_group_id = data.aws_ssm_parameter.bastion_sg_id.value
  #module.sg[9].sg_id
}

resource "aws_security_group_rule" "bastion-ssh" {
  count = var.sg_name == "bastion" ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = data.aws_ssm_parameter.bastion_sg_id.value
  cidr_blocks       = ["0.0.0.0/0"]
}
