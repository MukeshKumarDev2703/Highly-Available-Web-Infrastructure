## Variable for Database Instance Values
variable "db_instance_values" {
  description = "Database Instance Values"
  type = list(object({
    db_allocated_storage = number
    db_engine            = string
    db_engine_version    = string
    db_instance_class    = string
    db_engine_identifier = string

  }))
}

variable "db_config" {
  description = "Database configuration"
  type = object({
    multi_az            = bool
    publicly_accessible = bool
    storage_encrypted   = bool
    skip_final_snapshot = bool
  })
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}