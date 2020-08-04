data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = merge({
    Name = "GEPNET VPC"
  },local.CommonTags)
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  //tags                    = merge({"Name"="Public-${count.index}", "Type"= "Public"  },var.infra_tags)
  tags = merge({
    Name = "GEPNET Web Subnet"
  },local.CommonTags)
  #depends_on = [aws_vpc.principal]
}

resource "aws_subnet" "db" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]
  //tags                    = merge({"Name"="Public-${count.index}", "Type"= "Public"  },var.infra_tags)
  tags = merge({
    Name = "GEPNET DB1 Subnet"
  },local.CommonTags)
  #depends_on = [aws_vpc.principal]
}

resource "aws_subnet" "db2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]
  //tags                    = merge({"Name"="Public-${count.index}", "Type"= "Public"  },var.infra_tags)
  tags = merge({
    Name = "GEPNET DB2 Subnet"
  },local.CommonTags)
  #depends_on = [aws_vpc.principal]
}

#Create Internet GW for the production public subnets
resource "aws_internet_gateway" "GW-GepNet-Web" {
  vpc_id  = aws_vpc.main.id
  tags    = {
    Name="GW-GepNet-Web"
  }

}

#Create the route table with default route for the production public subnets
resource "aws_route_table" "RT-GepNet-Web" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.GW-GepNet-Web.id
  }

  tags = {
    Name="RT-GepNet-Web"
  }
}

resource "aws_route_table_association" "rt-public-association" {
   subnet_id      = aws_subnet.public.id
   route_table_id =  aws_route_table.RT-GepNet-Web.id
}
