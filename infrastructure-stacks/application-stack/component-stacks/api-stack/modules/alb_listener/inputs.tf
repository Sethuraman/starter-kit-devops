variable "aws_resource_prefix" {
  type = "string"
}

variable "api_target_group_name" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "api_path_pattern" {
  type = "string"
  default = "/api/*"
}

variable "alb_listener_arn" {
  type = "string"
}

variable "health_check_endpoint" {
  type = "string"
}