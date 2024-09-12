terraform {
  required_version = ">= 1.5.7"
  required_providers {
    aws = ">= 3.69.0"
  }
  backend "s3" {
    # Env specific backend settings are in **/backend.tf files
    region = "us-east-2"
  }
}

data "aws_caller_identity" "current" {}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = var.stage
      AppPrefix   = var.prefix
    }
  }
}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

module "tf_multi_env_example_vpc" {
  source = "./modules/vpc"
  prefix = var.prefix
}
