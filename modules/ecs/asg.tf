resource "aws_autoscaling_group" "ecs" {
  name                      = "${var.awsResourcePrefix}-${var.ecs_cluster_name}-asg"
  vpc_zone_identifier       = ["${split(",", var.ecs_subnets)}"]
  launch_configuration      = "${aws_launch_configuration.ecs.name}"
  health_check_grace_period = 300
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = "${var.asg_max_size}"
  desired_capacity          = "${var.asg_desired_size}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "ecs_scaleup" {
  name                   = "${var.awsResourcePrefix}-${var.ecs_cluster_name}-scaleup"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.ecs.name}"
}

resource "aws_autoscaling_policy" "ecs_scaledown" {
  name                   = "${var.awsResourcePrefix}-${var.ecs_cluster_name}-scaledown"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.ecs.name}"
}

resource "aws_cloudwatch_metric_alarm" "ecs_scaleup" {
  alarm_name          = "${var.awsResourcePrefix}-${var.ecs_cluster_name}-scaleup"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "50"

  dimensions {
    ClusterName = "${aws_ecs_cluster.ecs.name}"
  }

  alarm_description = "Cluster memory utilization above 50%"
  alarm_actions     = ["${aws_autoscaling_policy.ecs_scaleup.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "ecs_scaledown" {
  alarm_name          = "${var.awsResourcePrefix}-${var.ecs_cluster_name}-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "10"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "30"

  dimensions {
    ClusterName = "${aws_ecs_cluster.ecs.name}"
  }

  alarm_description = "Cluster memory utilization below 30%"
  alarm_actions     = ["${aws_autoscaling_policy.ecs_scaledown.arn}"]
}
