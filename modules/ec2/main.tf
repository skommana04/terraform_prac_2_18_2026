# resource "aws_instance" "example" {
#   ami           = local.ami_id
#   instance_type = "t3.medium"
#   vpc_security_group_ids = [ local.bastion_sg_id ]
#   subnet_id = local.public_subnet_id

#   tags = {
#     Terraform = true
#     Name = "${var.project}-${var.env}-bastion"
#   }
# }