## AWS Region
variable "aws_region" {
  description = "Region where all the resources will be created"
  type        = string
  default     = ""
}

## Prefix Name od Services
variable "name_prefix" {
  description = "This name will be used as a prefix for all the services"
  type        = string
  default     = ""
}
## Owner
variable "owner" {
  description = "owner name or owner type"
  type        = string
  default     = ""
}

## Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = ""
}


