### better to use more unique names, but good enough here

# EC2 INSTANCE

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "grafana" {
  name               = "grafana-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.default_tags
}

resource "aws_iam_role_policy_attachment" "ssm_managed_grafana" {
  role       = aws_iam_role.grafana.name
  policy_arn = data.aws_iam_policy.ssm_managed_instance.arn
}

resource "aws_iam_instance_profile" "grafana" {
  name = "grafana-instance-profile"
  role = aws_iam_role.grafana.name

  tags = var.default_tags
}

# BACKUP BUCKET

data "aws_iam_policy_document" "backup_bucket_put" {
  statement {
    sid       = "BackupBucketAccess"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.backups_grafana.arn}/*"]
  }
}

resource "aws_iam_policy" "backup_bucket_put" {
  name   = "grafana-backup-bucket-put-policy"
  policy = data.aws_iam_policy_document.backup_bucket_put.json

  tags = var.default_tags
}

resource "aws_iam_role_policy_attachment" "backup_bucket_put" {
  role       = aws_iam_role.grafana.name
  policy_arn = aws_iam_policy.backup_bucket_put.arn
}

# SCHEDULER

data "aws_iam_policy_document" "scheduler_ec2_policy" {
  statement {
    actions = [
      "ec2:StartInstances",
      "ec2:StopInstances"
    ]
    resources = [aws_instance.grafana.arn]
  }
}

data "aws_iam_policy_document" "scheduler_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "scheduler_ec2_role" {
  name               = "scheduler-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.scheduler_assume_role.json

  tags = var.default_tags
}

resource "aws_iam_role_policy" "scheduler_ec2_policy_attach" {
  name   = "scheduler-ec2-policy"
  role   = aws_iam_role.scheduler_ec2_role.id
  policy = data.aws_iam_policy_document.scheduler_ec2_policy.json
}
