provider "aws" {
  region = "${var.aws_region}"
}


module "stack" {
  source = "./modules/stack"
  region = "${var.aws_region}"
  aws_resource_prefix = "${var.aws_resource_prefix}"
  cluster_name = "${var.cluster_name}"
  ssh_key_name = "${var.ssh_key_name}"
  subnets = "${var.subnets}"
  vpc_id = "${var.vpc_id}"
  root_path_app_name = "${var.root_path_app_name}"
}