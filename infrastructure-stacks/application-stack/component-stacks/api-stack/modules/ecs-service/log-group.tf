resource "aws_cloudwatch_log_group" "service" {
  name = "${var.aws_resource_prefix}-${var.name}"
}