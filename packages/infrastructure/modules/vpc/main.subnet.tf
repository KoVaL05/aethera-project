resource "aws_subnet" "private_appsync_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = format("%s-private",data.aws_region.current.name)
}
