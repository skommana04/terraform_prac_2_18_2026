output "vpc_id" {
    value = module.vpc.vpc_id
}
output "azs" {
    value = data.aws_availability_zones.example
}