## This S3 Bucket is for Codepipeline Artifects.
resource "aws_s3_bucket" "codepipeline_artifact" {
  bucket        = "codepipeline-automation-s3-bucket"
  force_destroy = true
}

## This S3 Bucket is backend for terraform.tfstate.
resource "aws_s3_bucket" "backend_s3_bucket" {
  bucket        = "terraform-github-cicd-automation-s3"
  force_destroy = true
}

## DynamoDB tables for locking resources in CICD pipeline.(For Dev Environment)
resource "aws_dynamodb_table" "dev_table" {
  name           = "cicd-dev-dynamodb-table"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1
  attribute {
    name = "LockID"
    type = "S"
  }
  server_side_encryption {
    enabled = true
  }
}

## DynamoDB tables for locking resources in CICD pipeline.(For Stag Environment)
resource "aws_dynamodb_table" "stag_table" {
  name           = "cicd-stag-dynamodb-table"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1
  attribute {
    name = "LockID"
    type = "S"
  }
  server_side_encryption {
    enabled = true
  }
}