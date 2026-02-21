resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"

  tags = {
    Name = "${var.project}-${var.env}-${var.sg_name}"
  }
}