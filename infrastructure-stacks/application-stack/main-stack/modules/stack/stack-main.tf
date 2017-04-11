module "s3" {
  source = "../s3"
  aws_resource_prefix = "${var.aws_resource_prefix}"
  infraLogBucketName = "infra-logs"
}

module "alb" {
  source = "../alb"
  aws_resource_prefix = "${var.aws_resource_prefix}"
  name = "app"
  s3_logs_bucket_name = "${module.s3.infra_log_bucket_name}"
  s3_logs_bucket_id = "${module.s3.infra_log_bucket_id}"
  region = "${var.region}"
  subnets = "${var.subnets}"
  default_target_group_name = "${var.root_path_app_name}"
  vpc_id = "${var.vpc_id}"
}

module "ecs" {
  source = "../ecs"
  aws_resource_prefix = "${var.aws_resource_prefix}"
  ecs_cluster_name = "${var.cluster_name}"
  asg_desired_size = "1"
  asg_max_size = "1"
  ecs_subnets = "${var.subnets}"
  key_name = "${var.ssh_key_name}"
}
