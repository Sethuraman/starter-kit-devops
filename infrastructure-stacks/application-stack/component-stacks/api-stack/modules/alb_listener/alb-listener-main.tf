resource "aws_alb_target_group" "api" {
  name     = "${var.aws_resource_prefix}-${var.api_target_group_name}"
  /*
   We dont care about this port. It can be anything. We
   need a default for the target group to get created.
   When you use dynamic port mapping (setting the host port number as 0
   in a service), and the service registers itself with the ALB
   via this target group the correct port will be used.
  */
  port     = 8000
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  health_check {
    path = "${var.health_check_endpoint}"
  }
}


resource "aws_alb_listener_rule" "api" {
  listener_arn = "${var.alb_listener_arn}"
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