resource "aws_security_group" "allow_sg" {
  name        = local.full_sg_name
  vpc_id      = local.vpc_id

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.full_sg_name
  }
}

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