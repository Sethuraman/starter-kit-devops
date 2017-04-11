resource "aws_iam_role" "service" {
  name = "${var.aws_resource_prefix}-${var.name}-service-role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ecs.amazonaws.com", "ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "service" {
  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets"
    ]

    resources = [
      "*",
    ]
  }

}

resource "aws_iam_role_policy" "service" {
  name   = "${var.aws_resource_prefix}-${var.name}-service-policy"
  policy = "${data.aws_iam_policy_document.service.json}"
  role   = "${aws_iam_role.service.name}"
}
