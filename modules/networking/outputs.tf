output "vpc_id" {
    value = aws_vpc.main.id 
}
output "azs" {
    value = data.aws_availability_zones.example
}

output "public_subnet_ids" {
    value = aws_subnet.public[*].id
}