variable "name" {
  type = "string"
}

variable "aws_resource_prefix" {
  type = "string"
}

variable "ecs_cluster_id" {
  type = "string"
}

variable "number_of_containers" {
  type = "string"
}

variable "target_group_arn" {
  type = "string"
}

variable "container_port" {
  type = "string"
}

variable "image" {
  type = "string"
}

variable aws_region {
  type = "string"
}

variable "mininmum_cpu_units" {
  type = "string"
  default = "0"
}

variable "maximum_memory_in_mb" {
  type = "string"
  default = "124"
}

variable "logs_stream_prefix" {
  type = "string"
}

variable "deployment_minimum_healthy_percent" {
  type = "string"
}

variable "deployment_maximum_healthy_percent" {
  type = "string"
}
