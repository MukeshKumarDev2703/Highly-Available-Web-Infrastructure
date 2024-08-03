## Name of our Database security group
variable "database_sg_name" {
  description = "Name of our Database security group"
  type        = string
}

## Description for Database security group
variable "database_sg_description" {
  description = "Description for Database security group"
  type        = string
}

## Ingress Rules
variable "database_sg_ingress_rules" {
  description = "Database Ingress Rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

## Egress Rules
variable "database_sg_egress_rules" {
  description = "Database Egress Rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}