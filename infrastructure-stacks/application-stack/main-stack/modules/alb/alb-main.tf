resource "aws_alb" "application" {
  name            = "${var.aws_resource_prefix}-${var.name}"
  internal        = false
  security_groups = ["${aws_security_group.alb_sg_group.id}"]
  subnets         = ["${split(",", var.subnets)}"]

  access_logs {
    bucket = "${var.s3_logs_bucket_name}"
    # the prefix cannot start or end with a slash - remember that.
    prefix = "alb-access-logs/${var.aws_resource_prefix}-${var.name}"
  }
}

resource "aws_alb_target_group" "default" {
  name     = "${var.aws_resource_prefix}-${var.default_target_group_name}"
  /*
   We dont care about this port. It can be anything. We
   need a default for the target group to get created.
   When you use dynamic port mapping (setting the host port number as 0
   in a service), and the service registers itself with the ALB
   via this target group the correct port will be used.
  */
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}


resource "aws_alb_listener" "application" {
  load_balancer_arn = "${aws_alb.application.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.arn}"
    type             = "forward"
  }
}
