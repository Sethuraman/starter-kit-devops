data "template_file" "ecs_instance_user_data" {
  template = "${file("${path.module}/user-data.tpl")}"

  vars {
    cluster_name = "${aws_ecs_cluster.ecs.name}"
  }
}

resource "aws_launch_configuration" "ecs" {
  name_prefix          = "${var.awsResourcePrefix}-ecs-"
  security_groups      = [
    "${aws_security_group.ecs_alb_communication_sg_group.id}",
    "${aws_security_group.ecs_ssh_access.id}"
  ]
  image_id             = "${var.ecs_container_instance_ami}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"
  instance_type        = "${var.ecs_instance_type}"
  ebs_optimized        = "${var.ebs_optimised}"
  key_name             = "${var.key_name}"

  user_data = "${data.template_file.ecs_instance_user_data.rendered}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/xvdcz"
    volume_type           = "gp2"
    volume_size           = 100
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
