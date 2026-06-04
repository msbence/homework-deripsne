provider "aws" {
  region = var.aws_region
}

provider "digitalocean" {
  token = var.digitalocean_token
}
