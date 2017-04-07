variable "aws_region" {
  default = "ap-southeast-2"
}

provider "aws" {
  region = "${var.aws_region}"
}
