output "ec2_info" {
  value = {
    "id"              = aws_instance.grafana.id
    "dns_name"        = digitalocean_record.grafana_homework.fqdn 
    "connect_command" = "aws ssm start-session --target ${aws_instance.grafana.id}"
  }
}
