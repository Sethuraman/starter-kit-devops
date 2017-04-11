variable aws_resource_prefix {
  type = "string"
  default = "devops-starter"
}

variable "region" {
  type = "string"
}

variable "cluster_name" {
  type = "string"
}

variable "ssh_key_name" {
  type = "string"
}


/* Need to get the below configured via terraform */
variable subnets {
  type = "string"
}

variable vpc_id {
  type = "string"
}

variable root_path_app_name {
  type = "string"
}
