# Create the VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    "Name" = "MyVPC"
  }
}

# Get the available AZs
data "aws_availability_zone" "available" {
}

# Create the public subnets
resource "aws_subnet" "public" {
      count = 2
      vpc_id = aws_vpc.main.id
      cidr_block = var.public_subnet_cidr[count.index]
      availability_zone = data.aws_availability_zone.available.names[count.index]
      map_public_ip_on_launch = true
      tags = {
        "Name" = "MyPublicSubnet-${count.index + 1}"
      }
}

# Create the private subnets
resource "aws_subnet" "private" {
      count = 2
      vpc_id = aws_vpc.main.id
      cidr_block = var.private_subnet_cidr[count.index]
      availability_zone = data.aws_availability_zone.available.names[count.index]
      tags = {
        "Name" = "MyPrivateSubnet-${count.index + 1}"
      }
}

# Create the internet gateway
resource "aws_internet_gateway" "igw" {
      vpc_id = aws_vpc.main.id
      tags = {
        "Name" = "MyInternetGateway"
      }
}

# Create the NAT Gateway
resource "aws_eip" "nat" {
      count = 2
      tags = {
        "Name" = "nat-eip-${count.index + 1}"
      }
}

# Create the NAT Gateway
resource "aws_nat_gateway" "nat" {
      count = 2
      allocation_id = aws_eip.nat[count.index].id
      subnet_id = aws_subnet.public[count.index].id
      tags = {
        "Name" = "MyNATGateway-${count.index + 1}"
      }
}

resource "aws_route_table" "private" {
      count = 2
      vpc_id = aws_vpc.main.id

      route {
            cidr_block = "0.0.0.0/0"
            nat_gateway_id = aws_nat_gateway.nat[count.index].id
      }

      tags = {
            "Name" = "MyPrivateRouteTable-${count.index + 1}"
      }
}

resource "aws_route_table_association" "private_route_association" {
      count = 2
      subnet_id = aws_subnet.private[count.index].id
      route_table_id = aws_route_table.private[count.index].id
}