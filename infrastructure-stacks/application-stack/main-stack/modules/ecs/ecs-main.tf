resource "aws_ecs_cluster" "ecs" {
  name = "${var.ecs_cluster_name}"
}
