resource "aws_scheduler_schedule" "schedules" {
  for_each = local.scheduler_configuration

  name       = format("%s-schedule-%s", var.random_name, each.key)
  group_name = "default"

  schedule_expression = each.value.schedule

  flexible_time_window {
    mode = "OFF"
  }

  target {
    arn      = each.value.lambda.arn
    role_arn = aws_iam_role.event_bridge_roles[each.key].arn
  }
}