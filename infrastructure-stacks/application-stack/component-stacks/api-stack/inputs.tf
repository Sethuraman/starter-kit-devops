variable application_main_stack_state_file {
  type = "string"
}

variable "aws_region" {
  type = "string"
}

variable "aws_resource_prefix" {
  type = "string"
}

variable "name" {
  type = "string"
}

variable "number_of_containers" {
  type = "string"
}

variable "container_port" {
  type = "string"
}

variable "image" {
  type = "string"
}

variable "logs_stream_prefix" {
  type = "string"
}

variable "deployment_minimum_healthy_percent" {
  type = "string"
  default = 100
}

variable "deployment_maximum_healthy_percent" {
  type = "string"
  default = 200
}

variable "health_check_endpoint" {
  type = "string"
}