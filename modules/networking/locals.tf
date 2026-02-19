locals {
    common_tags = {
        Project = var.project
        Environment = var.env
        Terraform = true
    }
    vpc_resource_name = "${var.project}-${var.env}-vpc"
    igw_resource_name = "${var.project}-${var.env}-igw"
    az_list = slice(data.aws_availability_zones.example.names, 0,2)
    public_subnet_resource_names = "${var.project}-${var.env}-publicsubnet"
    private_subnet_resource_names = "${var.project}-${var.env}-privatesubnet"
    database_subnet_resource_names = "${var.project}-${var.env}-databasesubnet"

}