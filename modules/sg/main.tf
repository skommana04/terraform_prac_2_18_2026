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