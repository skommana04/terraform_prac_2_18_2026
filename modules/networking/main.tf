resource "aws_vpc" "main" {
  cidr_block = var.cidr
  enable_dns_hostnames = true
  tags = merge(
    local.common_tags,
    {
        Name = local.vpc_resource_name
    }
  )
}