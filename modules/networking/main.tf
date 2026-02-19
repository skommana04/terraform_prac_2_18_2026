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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge (
    local.common_tags,
    {
        Name = local.igw_resource_name
    }
  )  
}
# i want to create 2 public subnets  in two az's 1a and 1b
# resource "aws_subnet" "public" {
#     count =     length(var.public_cidrs)
#     vpc_id     = aws_vpc.main.id
#     cidr_block = var.public_cidrs[count.index]
#      availability_zone   = data.aws_availability_zones.available.names[0]

#     tags = merge (
#         local.common_tags,
#         {
#             Name = 
#         }
#     )
# }