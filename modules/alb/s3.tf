data "aws_iam_policy_document" "infra_alb_log_bucket" {
  statement {
    sid = "1"
     actions = [
       "s3:PutObject"
     ]
     resources = [
       "arn:aws:s3:::${var.s3_logs_bucket_name}/alb-access-logs/${var.aws_resource_prefix}-${var.name}/*"
     ]
     principals = {
       type = "AWS"
       identifiers = ["${lookup(var.alb_account_ids, var.region)}"]
     }
  }
}

resource "aws_s3_bucket_policy" "infra_alb_log_bucket" {
  bucket = "${var.s3_logs_bucket_id}"
  policy = "${data.aws_iam_policy_document.infra_alb_log_bucket.json}"
}
