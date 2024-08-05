terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
  backend "s3" {}
}

# Configure the AWS Provider
provider "aws" {
  profile = "default"
  region  = var.aws_region
}
