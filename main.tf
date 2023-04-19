provider "aws" {
  region = var.region
}

# vpc
resource "aws_vpc" "default" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "ecs_example"
  }
}

# subnet
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.default.id
  availability_zone       = var.public_az1
  cidr_block              = var.public_subnet1
  tags = {
    Name = "ecs-example-public-1a"
  }
}

resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.default.id
  availability_zone       = var.public_az2
  cidr_block              = var.public_subnet2
  tags = {
    Name = "ecs-example-public-1b"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id                  = aws_vpc.default.id
  availability_zone       = var.private_az1
  cidr_block              = var.private_subnet1
  tags = {
    Name = "ecs-example-private-1a"
  }
}

resource "aws_subnet" "private_1b" {
  vpc_id                  = aws_vpc.default.id
  availability_zone       = var.private_az2
  cidr_block              = var.private_subnet2
  tags = {
    Name = "ecs-example-private-1b"
  }
}

# internet gateway
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.default.id
}

# nat
resource "aws_eip" "nat_1a" {
  vpc        = true
  tags       = {
        Name = "ecs-example-nat-1a"
  }
}

resource "aws_nat_gateway" "nat_1a" {
  subnet_id     = "${aws_subnet.public_1a.id}"
  allocation_id = "${aws_eip.nat_1a.id}"
}

resource "aws_eip" "nat_1b" {
  vpc        = true
  tags       = {
        Name = "ecs-example-nat-1b"
  }
}

resource "aws_nat_gateway" "nat_1b" {
  subnet_id     = "${aws_subnet.public_1b.id}"
  allocation_id = "${aws_eip.nat_1b.id}"
}

# public route
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "ecs-example-public"
  }
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = "${aws_route_table.public.id}"
  gateway_id             = "${aws_internet_gateway.gateway.id}"
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = "${aws_subnet.public_1a.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public_1b" {
  subnet_id  = "${aws_subnet.public_1b.id}"
  route_table_id = "${aws_route_table.public.id}"
}

# private route
resource "aws_route_table" "private_1a" {
  vpc_id = "${aws_vpc.default.id}"
  tags = {
    Name = "ecs-example-private_1a"
  }
}

resource "aws_route" "private_1a" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = "${aws_route_table.private_1a.id}"
  nat_gateway_id         = "${aws_nat_gateway.nat_1a.id}"
}

resource "aws_route_table_association" "private_1a" {
  subnet_id  = "${aws_subnet.private_1a.id}"
  route_table_id = "${aws_route_table.private_1a.id}"
}

resource "aws_route_table" "private_1b" {
  vpc_id = "${aws_vpc.default.id}"
  tags = {
    Name = "ecs-example-private_1b"
  }
}

resource "aws_route" "private_1b" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = "${aws_route_table.private_1b.id}"
  nat_gateway_id         = "${aws_nat_gateway.nat_1b.id}"
}

resource "aws_route_table_association" "private_1b" {
  subnet_id  = "${aws_subnet.private_1b.id}"
  route_table_id = "${aws_route_table.private_1b.id}"
}
