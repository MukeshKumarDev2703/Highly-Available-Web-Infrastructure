## Name of our Private security group
variable "private_sg_name" {
  description = "Name of our Private security group"
  type        = string
}

## Description for Private security group
variable "private_sg_description" {
  description = "Description for Private security group"
  type        = string
}

## Ingress Rules
variable "private_sg_ingress_rules" {
  description = "Private Ingress Rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

## Egress Rules
variable "private_sg_egress_rules" {
  description = "Private Egress Rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}