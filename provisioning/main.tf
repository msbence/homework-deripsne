# of course, this should normally be route53
#data "digitalocean_domain" "mbraptor_tech" {
#  name = "mbraptor.tech"
#}

data "aws_vpc" "default" {
  default = true
}

data "aws_vpc_endpoint_service" "s3" {
  service      = "s3"
  service_type = "Gateway"
}

data "aws_iam_policy" "ssm_managed_instance" {
  name = "AmazonSSMManagedInstanceCore"
}

# https://cloud-images.ubuntu.com/locator/ec2/
data "aws_ami" "ubuntu_noble" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
