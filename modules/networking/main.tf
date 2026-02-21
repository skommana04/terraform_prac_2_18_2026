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
#i want to create 2 public subnets  in two az's 1a and 1b
resource "aws_subnet" "public" {
    count =     length(var.public_cidrs)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.public_cidrs[count.index]
    availability_zone   = local.az_list[count.index]
    map_public_ip_on_launch = true

    tags = merge (
        local.common_tags,
        {
            Name = "${local.public_subnet_resource_names}-${local.az_list[count.index]}"
        }
    )
}

resource "aws_subnet" "private" {
    count =     length(var.private_cidrs)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.private_cidrs[count.index]
    availability_zone   = local.az_list[count.index]
  
    tags = merge (
        local.common_tags,
        {
            Name = "${local.private_subnet_resource_names}-${local.az_list[count.index]}"
        }
    )
}

resource "aws_subnet" "database" {
    count =     length(var.database_cidrs)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.database_cidrs[count.index]
    availability_zone   = local.az_list[count.index]
  
    tags = merge (
        local.common_tags,
        {
            Name = "${local.database_subnet_resource_names}-${local.az_list[count.index]}"
        }
    )
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

    tags = merge (
        local.common_tags,
        {
            Name = local.public_routetable_resource_name
        }
    )
}
resource "aws_route" "public_r" {
  route_table_id            = aws_route_table.public_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public-rta" {
  count = length(var.public_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

##eip
resource "aws_eip" "example" {
  # In a VPC, the 'domain' attribute defaults to "vpc". 
  # Setting it explicitly helps ensure the correct behavior.
  domain = "vpc" 

  tags = {
    Name = "unassociated-eip"
  }
}

##nat
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

    tags = merge (
        local.common_tags,
        {
            Name = local.private_routetable_resource_name
        }
    )
}
resource "aws_route" "private_r" {
  route_table_id            = aws_route_table.private_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.example.id
}

resource "aws_route_table_association" "private-rta" {
  count = length(var.private_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_ssm_parameter" "vpc_id" {
  name  = "${var.project}-${var.env}-vpc_id"
  type  = "String"
  value = aws_vpc.main.id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project}/${var.env}/public_subnet_ids"
  type  = "StringList"
  value = join(",", aws_subnet.public[*].id)
}