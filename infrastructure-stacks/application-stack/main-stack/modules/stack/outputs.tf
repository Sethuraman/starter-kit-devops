output alb_arn {
  value = "${module.alb.alb_arn}"
}

output alb_listener_arn {
  value = "${module.alb.alb_listener_arn}"
}

output ecs_cluster_id {
  value = "${module.ecs.ecs_cluster_id}"
}