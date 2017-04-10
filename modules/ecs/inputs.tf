# Mandatory variables that need to be provided
variable "aws_resource_prefix" {
  type = "string"
}

variable "ecs_cluster_name" {
  type = "string"
}

variable "key_name" {
  type = "string"
}

variable "ecs_subnets" {
  type        = "string"
  description = "specify all subnets with a comma separator and no spaces in between"
}

variable "asg_max_size" {
  type = "string"
}

variable "asg_desired_size" {
  type = "string"
}

# Optional Variables that use defaults if not provided
variable "ecs_container_instance_ami" {
  type = "string"

  # defaults to Amazon Linux AMI 2016.09.g x86_64 ECS HVM GP2
  default = "ami-fbe9eb98"
}

variable "ecs_instance_type" {
  type = "string"

  default = "t2.micro"
}
