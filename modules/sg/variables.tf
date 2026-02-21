variable "project" {
    default = "roboshop"
    type = string
}

variable "env" {
    default = "dev"
    type = string
}
variable vpc_ssm_param_name {}
variable "sg_name" {}