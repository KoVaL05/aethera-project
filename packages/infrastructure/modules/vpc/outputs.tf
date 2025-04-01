output "private_appsync_vpc_id" {
  value = aws_vpc.main.id
}

output "private_appsync_sg_id" {
  value = aws_security_group.appsync_endpoint.id
}

output "private_appsync_subnet_ids" {
  value = jsonencode([aws_subnet.private_appsync_subnet_a.id, aws_subnet.private_appsync_subnet_b.id, aws_subnet.private_appsync_subnet_c.id])
}