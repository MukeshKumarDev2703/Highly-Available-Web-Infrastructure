## Main resource file for private security group
resource "aws_security_group" "private_sg" {
  vpc_id      = aws_vpc.main.id
  name        = "${local.name_prefix}-${var.private_sg_name}"
  description = var.private_sg_description
  dynamic "ingress" {
    for_each = var.private_sg_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = var.private_sg_egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = local.common_tags
}

## Private Security Group IDS
output "private_security_group" {
  description = "Private Security Group ID"
  value       = aws_security_group.private_sg.id
}
## Private Security Group Names
output "private_security_group_name" {
  description = "Private Security Group Name"
  value       = aws_security_group.private_sg.name
}