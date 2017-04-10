resource "aws_s3_bucket" "infra_log_bucket" {
  bucket = "${var.aws_resource_prefix}-${var.infraLogBucketName}"
  acl = "private"
}