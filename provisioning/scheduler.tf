# https://docs.aws.amazon.com/solutions/latest/instance-scheduler-on-aws/solution-overview.html
#resource "aws_cloudformation_stack" "instance_scheduler" {
#  name         = "aws_instance_scheduler"
#  template_url = "https://s3.amazonaws.com/solutions-reference/instance-scheduler-on-aws/latest/instance-scheduler-on-aws.template"
#} Generates costs, a bit too much for one EC2. Find something more lightweight, ideally free...

###

# idea stolen from here: https://github.com/SantyMaran/EC2-Scheduler/blob/main/main.tf

resource "aws_scheduler_schedule_group" "schedule_grafana" {
  name = "cost-control-grafana"

  tags = var.default_tags
}

resource "aws_scheduler_schedule" "start_grafana" {
  name       = "start-grafana"
  group_name = aws_scheduler_schedule_group.schedule_grafana.name

  flexible_time_window {
    mode = "OFF"
  }

  # AWS Docs: "You can't use * in both the Day-of-month and Day-of-week fields.
  # If you use it in one, you must use ? in the other." -> interesting...
  schedule_expression          = "cron(0 6 * * ? *)" # start at 06:00 UTC
  schedule_expression_timezone = "UTC"               # default, but let's be explicit

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
    role_arn = aws_iam_role.scheduler_ec2_role.arn

    input = jsonencode({
      InstanceIds = [aws_instance.grafana.id]
    })
  }
}

resource "aws_scheduler_schedule" "stop_grafana" {
  name       = "stop-grafana"
  group_name = aws_scheduler_schedule_group.schedule_grafana.name

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = "cron(0 20 * * ? *)" # shutdown at 20:00 UTC
  schedule_expression_timezone = "UTC"                # default, but let's be explicit

  target {
    arn      = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
    role_arn = aws_iam_role.scheduler_ec2_role.arn

    input = jsonencode({
      InstanceIds = [aws_instance.grafana.id]
    })
  }
}
