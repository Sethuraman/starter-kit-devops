resource "aws_security_group" "ecs_alb_communication_sg_group" {
  name        = "${var.aws_resource_prefix}-ecs_alb_communication_sg_group"
  description = "Allow all inbound traffic on ephemeral port range - 32768 - 61000"

  ingress {
    from_port   = 32768
    to_port     = 61000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "ecs_ssh_access" {
  name        = "${var.aws_resource_prefix}-ecs_ssh_access"
  description = "Allow all inbound traffic on port 22"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  lifecycle {
    create_before_destroy = true
  }
}
