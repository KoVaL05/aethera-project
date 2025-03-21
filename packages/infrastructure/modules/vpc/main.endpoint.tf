resource "aws_vpc_endpoint" "appsync" {
  vpc_id            = aws_vpc.main.id
  service_name      = format("com.amazonaws.%s.appsync-api",data.aws_region.current.name)
  vpc_endpoint_type = "Interface"
  
  subnet_ids          = [aws_subnet.private_appsync_subnet_a.id,aws_subnet.private_appsync_subnet_b.id,aws_subnet.private_appsync_subnet_c.id]
  security_group_ids  = [aws_security_group.appsync_endpoint.id]
  
  private_dns_enabled = true
}
