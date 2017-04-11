variable aws_resource_prefix {
  type = "string"
  description = "This is string that will be prefixed to all resources created like a namspace. Leave it empty if you dont want it."
}

variable cluster_name {
  type = "string"
}

variable ssh_key_name {
  type = "string"
}

variable root_path_app_name {
  type = "string"
}

variable subnets {
  type = "string"
}

variable vpc_id {
  type = "string"
}

variable "aws_region" {
  type = "string"
}
