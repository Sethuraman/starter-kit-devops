provider "aws" {
  region = "${var.aws_region}"
}


data "terraform_remote_state" "application_main_stack" {
  backend = "local"

  config {
    path = "${path.module}/${var.application_main_stack_state_file}"
  }
}

module "alb" {
  source = "./modules/alb_listener"
  api_target_group_name = "api"
  vpc_id = "${data.terraform_remote_state.application_main_stack.vpc_id}"
  api_path_pattern = "/api/*"
  alb_listener_arn = "${data.terraform_remote_state.application_main_stack.alb_listener_arn}"
  aws_resource_prefix = "${var.aws_resource_prefix}"
  health_check_endpoint = "${var.health_check_endpoint}"
}

module "ecs_service" {
  source = "./modules/ecs-service"
  aws_resource_prefix = "${var.aws_resource_prefix}"
  ecs_cluster_id = "${data.terraform_remote_state.application_main_stack.ecs_cluster_id}"
  name = "${var.name}"
  number_of_containers = "${var.number_of_containers}"
  target_group_arn = "${module.alb.target_group_arn}"
  container_port = "${var.container_port}"
  aws_region = "${var.aws_region}"
  image = "${var.image}"
  logs_stream_prefix = "${var.logs_stream_prefix}"
  deployment_maximum_healthy_percent = "${var.deployment_maximum_healthy_percent}"
  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
}


