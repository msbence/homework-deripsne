resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow HTTP/HTTPS inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  tags = var.default_tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_web.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"

  tags = var.default_tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.allow_web.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"

  tags = var.default_tags
}

resource "aws_security_group" "allow_egress_all" {
  name        = "allow_egress_all"
  description = "Allow all outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  tags = var.default_tags
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.allow_egress_all.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

  tags = var.default_tags
}
