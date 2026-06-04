#resource "digitalocean_record" "a" {
#  domain = data.digitalocean_domain.mbraptor_tech.id
#  type   = "A"
#  name   = "grafana-homework"
#  value  = aws_eip.grafana.public_ip
#  ttl    = 60
#}
