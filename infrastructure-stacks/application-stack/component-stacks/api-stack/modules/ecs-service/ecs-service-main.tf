data "template_file" "container_definition" {
  template = "${file("${path.module}/container-definition.tpl")}"
  vars {
    name = "${var.aws_resource_prefix}-${var.name}"
    image = "${var.image}"
    minimum_cpu_units = "${var.mininmum_cpu_units}"
    maximum_memory_in_mb = "${var.maximum_memory_in_mb}"
    container_port = "${var.container_port}"
    aws_region = "${var.aws_region}"
    logs_stream_prefix = "${var.logs_stream_prefix}"
  }
}


resource "aws_ecs_task_definition" "task_definition" {
  family                = "${var.aws_resource_prefix}-${var.name}"
  container_definitions = "${data.template_file.container_definition.rendered}"
}

resource "aws_ecs_service" "service" {
  name            = "${var.aws_resource_prefix}-${var.name}"
  cluster         = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.task_definition.arn}"
  desired_count   = "${var.number_of_containers}"
  iam_role        = "${aws_iam_role.service.arn}"
  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
  deployment_maximum_percent = "${var.deployment_maximum_healthy_percent}"
  depends_on      = ["aws_iam_role_policy.service"]

  placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = "${var.target_group_arn}"
    container_name = "${var.aws_resource_prefix}-${var.name}"
    container_port = "${var.container_port}"
  }

}



