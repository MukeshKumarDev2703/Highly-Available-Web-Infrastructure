locals {
  name_prefix = var.name_prefix
  owner       = var.owner
  environment = var.environment

  common_tags = {
    Owner       = local.owner
    Environment = local.environment
  }
}