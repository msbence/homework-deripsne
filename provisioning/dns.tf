resource "digitalocean_record" "grafana_homework" {
  domain = data.digitalocean_domain.mbraptor_tech.id
  type   = "A"
  name   = "grafana-homework"
  value  = aws_eip.grafana.public_ip
  ttl    = 60
}
