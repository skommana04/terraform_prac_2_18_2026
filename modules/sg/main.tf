resource "aws_security_group" "allow_sg" {
  name        = local.full_sg_name
  vpc_id      = local.vpc_id

  tags = {
    Name = local.full_sg_name
  }
}