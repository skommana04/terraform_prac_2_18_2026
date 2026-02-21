variable "sg_name" {}
variable "project" {
    default = "roboshop"
    type = string
}

variable "env" {
    default = "dev"
    type = string
}

variable "frontend_sg_id" {}
variable "frontend-alb_sg_id" {}
variable "backend-alb_sg_id" {}
variable "bastion_sg_id" {}