locals {
  scheduler_configuration = {
    create_vpc_endpoint = {
      lambda     = var.lambda_functions["create_vpc_endpoint"]
      schedule   = "cron(15 12 ? * SAT,SUN *)"
      group_name = "vpc_endpoint"
    }
    delete_vpc_endpoint = {
      lambda     = var.lambda_functions["delete_vpc_endpoint"]
      schedule   = "cron(0 0,12 ? * * *)"
      group_name = "vpc_endpoint"
    }
  }
}