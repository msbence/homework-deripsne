resource "aws_s3_bucket" "ssm_store" {
  bucket = "bencemadarasz-hw-ssm-store"

  tags = var.default_tags
}

resource "aws_s3_bucket" "backups_grafana" {
  bucket = "bencemadarasz-hw-backups-grafana"

  tags = var.default_tags
}

# no use for this one, useful assuming a dedicated backup account 
resource "aws_s3_bucket_ownership_controls" "backups_grafana" {
  bucket = aws_s3_bucket.backups_grafana.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "backups_grafana" {
  bucket = aws_s3_bucket.backups_grafana.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "backups_grafana" {
  bucket = aws_s3_bucket.backups_grafana.id

  rule {
    default_retention {
      mode = "GOVERNANCE" # On prod, I would go COMPLIANCE
      days = 3
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.backups_grafana
  ]
}

resource "aws_s3_bucket_lifecycle_configuration" "backups_grafana" {
  bucket = aws_s3_bucket.backups_grafana.id

  rule {
    id     = "grafana-backup-retention"
    status = "Enabled"

    # assuming each file will be differently named. otherwise -> noncurrent_version
    transition {
      days          = 2
      storage_class = "GLACIER"
    }

    expiration {
      days = 4
    }
  }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = data.aws_vpc.default.id
  service_name = data.aws_vpc_endpoint_service.s3.service_name

  tags = var.default_tags
}
