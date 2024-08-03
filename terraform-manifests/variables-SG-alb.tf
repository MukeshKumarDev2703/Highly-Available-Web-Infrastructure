## ALB Security Group Name
variable "alb_sg_name" {
  description = "Name of our Security group"
  type        = string
}

## Description for Security Group
variable "alb_sg_description" {
  type = string
}

## Ingress Rules
variable "alb_sg_ingress_rules" {
  description = "ALB Ingress Rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

## Egress Rules
variable "alb_sg_egress_rules" {
  description = "ALB Egress Rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}