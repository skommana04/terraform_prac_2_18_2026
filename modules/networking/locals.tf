locals {
    common_tags = {
        Project = var.project
        Environment = var.env
        Terraform = true
    }
    vpc_resource_name = "${var.project}-${var.env}-vpc"
    igw_resource_name = "${var.project}-${var.env}-igw"
}