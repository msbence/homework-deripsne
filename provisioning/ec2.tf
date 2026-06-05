resource "aws_instance" "grafana" {
  instance_type     = "t3.micro"
  ami               = data.aws_ami.ubuntu_noble.id
  availability_zone = "${var.aws_region}${var.aws_az}"

  iam_instance_profile = aws_iam_instance_profile.grafana.name
  vpc_security_group_ids = [
    aws_security_group.allow_web.id,
    aws_security_group.allow_egress_all.id
  ]

  root_block_device {
    volume_size = 10
    encrypted   = true
  }

  lifecycle {
    ignore_changes = [
      ami # this instance is stateful, do not recreate on AMI change
    ]

    prevent_destroy = false # on prod this is a good idea to be set to true, but not doing that here
  }

  tags = merge(
    {
      "Name" : "bencemadarasz-grafana"
    },
    var.default_tags
  )
}

resource "aws_eip" "grafana" {
  instance = aws_instance.grafana.id

  tags = var.default_tags
}

resource "aws_ebs_volume" "grafana_zfs" {
  count = 2

  availability_zone = aws_instance.grafana.availability_zone
  size              = 5
  encrypted         = true

  tags = var.default_tags
}

resource "aws_volume_attachment" "grafana_zfs" {
  count = length(aws_ebs_volume.grafana_zfs)

  device_name = element(["/dev/sdf", "/dev/sdg"], count.index) # a bit hacky, but better than having 2x the code
  volume_id   = aws_ebs_volume.grafana_zfs[count.index].id
  instance_id = aws_instance.grafana.id
}
