output alb_arn {
  value = "${aws_alb.application.arn}"
}

output alb_listener_arn {
  value = "${aws_alb_listener.application.arn}"
}