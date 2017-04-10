resource "aws_alb" "application" {
  name            = "${var.aws_resource_prefix}-${var.name}"
  internal        = false
  security_groups = ["${aws_security_group.alb_sg_group.id}"]
  subnets         = ["${split(",", var.subnets)}"]

  enable_deletion_protection = true

  access_logs {
    bucket = "${var.s3_logs_bucket_name}"
    # the prefix cannot start or end with a slash - remember that.
    prefix = "alb-access-logs/${var.aws_resource_prefix}-${var.name}"
  }
}

resource "aws_alb_target_group" "api" {
  name     = "${var.api_target_group_name}"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}


resource "aws_alb_target_group" "ui" {
  name     = "${var.ui_target_group_name}"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_alb_listener" "application" {
  load_balancer_arn = "${aws_alb.application.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.ui.arn}"
    type             = "forward"
  }
}


// the UI target group listener rule is missing as the default
// mapping to the UI suffices

resource "aws_alb_listener_rule" "api" {
  listener_arn = "${aws_alb_listener.application.arn}"
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.api.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["${var.api_path_pattern}"]
  }
}