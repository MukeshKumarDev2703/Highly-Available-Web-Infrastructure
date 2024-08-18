## Main resource file for Appliccation Load Balancer security group
resource "aws_security_group" "alb_sg" {
  vpc_id      = aws_vpc.main.id
  name        = "${local.name_prefix}-${var.alb_sg_name}"
  description = var.alb_sg_description
  dynamic "ingress" {
    for_each = var.alb_sg_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = var.alb_sg_egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix}-${var.alb_values.name}"
    }
  )
}

## ALB Security Group IDS
output "alb_security_group" {
  description = "ALB Security Group ID"
  value       = aws_security_group.alb_sg.id
}
## ALB Security Group Names
output "alb_security_group_name" {
  description = "ALB Security Group Name"
  value       = aws_security_group.alb_sg.name
}