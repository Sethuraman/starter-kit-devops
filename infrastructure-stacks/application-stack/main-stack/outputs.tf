output vpc_id {
  value = "${var.vpc_id}"
}

output alb_arn {
  value = "${module.stack.alb_arn}"
}

output alb_listener_arn {
  value = "${module.stack.alb_listener_arn}"
}

output ecs_cluster_id {
  value = "${module.stack.ecs_cluster_id}"
}