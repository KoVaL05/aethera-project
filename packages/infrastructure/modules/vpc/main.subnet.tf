resource "aws_subnet" "private_appsync_subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = format("%sa", data.aws_region.current.name)
}

resource "aws_subnet" "private_appsync_subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = format("%sb", data.aws_region.current.name)
}

resource "aws_subnet" "private_appsync_subnet_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = format("%sc", data.aws_region.current.name)
}