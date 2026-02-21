resource "aws_security_group" "allow_sg" {
  name        = local.sg_name
  vpc_id      = local.vpc_id

  tags = {
    Name = local.sg_name
  }
}