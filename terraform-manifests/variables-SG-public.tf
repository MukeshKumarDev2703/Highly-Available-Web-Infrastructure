## Public Security Group Name
variable "public_sg_name" {
  description = "Name of our Security group"
  type        = string
}

## Description for Security Group
variable "public_sg_description" {
  type = string
}

## Ingress Rules
variable "public_sg_ingress_rules" {
  description = "Public Ingress Rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

## Egress Rules
variable "public_sg_egress_rules" {
  description = "Public Egress Rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}