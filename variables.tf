variable "stage" {
  type        = string
  description = "define the stage: sandbox, prod"
}

variable "aws_region" {
  type        = string
  description = "define the aws region"
}

variable "prefix" {
  type        = string
  description = "define the prefix for each provisioned resource"
}
