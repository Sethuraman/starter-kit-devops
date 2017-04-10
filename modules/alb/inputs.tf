# Mandatory variables that need to be provided
variable "aws_resource_prefix" {
  type = "string"
}

variable "name" {
  type = "string"
}

variable "s3_logs_bucket_name" {
  type = "string"
}

variable "s3_logs_bucket_id" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "subnets" {
  type = "string"
  description = "specify all subnets with a comma separator and no spaces in between"
}

variable "api_target_group_name" {
  type = "string"
}

variable "ui_target_group_name" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

# Defaults that don't have to be provided
variable "alb_account_ids" {
  type = "map"
  default = {
    us-east-1 = "127311923021"
    us-east-2 = "033677994240"
    us-west-1 = "027434742980"
    us-west-2 = "797873946194"
    ca-central-1 = "985666609251"
    eu-west-1 = "156460612806"
    eu-central-1 = "054676820928"
    eu-west-2 = "652711504416"
    ap-northeast-1 = "582318560864"
    ap-northeast-2 = "600734575887"
    ap-southeast-1 = "114774131450"
    ap-southeast-2 = "783225319266"
    ap-south-1 = "718504428378"
    sa-east-1 = "507241528517"
  }
}

variable "api_path_pattern" {
  type = "string"
  default = "/api/*"
}