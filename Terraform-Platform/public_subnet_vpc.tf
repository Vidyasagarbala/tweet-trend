resource "aws_vpc" "dev-ops" {
  cidr_block = var.cidr_vpc
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.dev-ops.id
  cidr_block = var.cidr_subnet

  tags = {
    Name = "dev-ops"
  }

  depends_on = [ aws_vpc.dev-ops ]
}

resource "aws_internet_gateway" "igw" {
  //name = "dev-ops-igw"
  vpc_id = aws_vpc.dev-ops.id

  tags = {
    Name = "dev-ops"
  }
}

resource "aws_route_table" "public_subnet_routetable" {
  vpc_id = aws_vpc.dev-ops.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  route {
    cidr_block = var.cidr_subnet
    gateway_id = "local"
  }
  
  depends_on = [ aws_subnet.public-subnet ]
}


resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public_subnet_routetable.id
  depends_on = [ aws_route_table.public_subnet_routetable ]
}