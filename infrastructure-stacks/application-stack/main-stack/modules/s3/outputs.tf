output "infra_log_bucket_name" {
  value = "${aws_s3_bucket.infra_log_bucket.bucket}"
}

output "infra_log_bucket_id" {
  value = "${aws_s3_bucket.infra_log_bucket.id}"
}

