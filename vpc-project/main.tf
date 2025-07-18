resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    "Name" = "MyVPC"
  }
}

data "aws_availability_zone" "available" {
}

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

resource "aws_subnet" "private" {
      count = 2
      vpc_id = aws_vpc.main.id
      cidr_block = var.private_subnet_cidr[count.index]
      availability_zone = data.aws_availability_zone.available.names[count.index]
      tags = {
        "Name" = "MyPrivateSubnet-${count.index + 1}"
      }
}

resource "aws_internet_gateway" "igw" {
      vpc_id = aws_vpc.main.id
      tags = {
        "Name" = "MyInternetGateway"
      }
}
