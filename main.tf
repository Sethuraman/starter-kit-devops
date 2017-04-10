variable "aws_region" {
  default = "ap-southeast-2"
}

provider "aws" {
  region = "${var.aws_region}"
}

module "stack" {
  source = "./modules/stack"
  region = "${var.aws_region}"
  aws_resource_prefix = "devops-starter"
  cluster_name = "sethu-test1"
  ssh_key_name = "sethu-ecs"
  subnets = "${var.subnets}"
  vpc_id = "${var.vpc_id}"
}