output "vpc_id" {
    value = module.vpc.vpc_id
}
output "azs" {
    value = module.vpc.azs
}
output "sg_id" {
    value = module.sg[*].sg_id
}