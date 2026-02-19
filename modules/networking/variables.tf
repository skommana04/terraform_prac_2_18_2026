variable "cidr" {
    type = string
    default = "10.0.0.0/16"
    description = "The IP address range for VPC"
}

variable "project" {
    default = "roboshop"
    type = string
}

variable "env" {
    default = "dev"
    type = string
}

variable "public_cidrs" {
    type = list
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}
   
