output "ec2_info" {
  value = {
    "id"              = aws_instance.grafana.id
    "dns_name"        = aws_instance.grafana.public_dns
    "connect_command" = "aws ssm start-session --target ${aws_instance.grafana.id}"
  }
}
