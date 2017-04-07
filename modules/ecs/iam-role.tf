resource "aws_iam_role" "ecs_instance" {
  name = "${var.awsResourcePrefix}-ecsInstance-role"
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

data "aws_iam_policy_document" "ecs_policy" {
  statement {
    actions = [
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:Submit*",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }

  statement {
    actions = [
      "cloudwatch:PutMetricData",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "ecs" {
  name   = "${var.awsResourcePrefix}-ecsInstance-policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.ecs_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_role_policy_attach" {
  role       = "${aws_iam_role.ecs_instance.name}"
  policy_arn = "${aws_iam_policy.ecs.arn}"
}

# An instance profile is a container for an IAM role that you can use to pass 
# role information to an EC2 instance when the instance starts.
# If you use the AWS Management Console to create a role for Amazon EC2, 
# the console automatically creates an instance profile and gives it the 
# same name as the role. When you then use the Amazon EC2 console to launch an instance 
# with an IAM role, you can select a role to associate with the instance. In the console, 
# the list that's displayed is actually a list of instance profile names. 
# The console does not create an instance profile for a role that is not associated with Amazon EC2.
resource "aws_iam_instance_profile" "ecs" {
  name  = "${var.awsResourcePrefix}-ecsInstanceRole"
  path  = "/"
  roles = ["${aws_iam_role.ecs_instance.name}"]
}
