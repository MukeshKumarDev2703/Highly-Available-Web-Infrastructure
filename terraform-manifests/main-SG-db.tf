## Main resource file for database security group
resource "aws_security_group" "database_sg" {
  vpc_id      = aws_vpc.main.id
  name        = "${local.name_prefix}-${var.database_sg_name}"
  description = var.database_sg_description
  dynamic "ingress" {
    for_each = var.database_sg_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = var.database_sg_egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = local.common_tags
}

## Database Security Group IDS
output "database_security_group" {
  description = "Database Security Group ID"
  value       = aws_security_group.database_sg.id
}
## Database Security Group Names
output "database_security_group_name" {
  description = "Database Security Group Name"
  value       = aws_security_group.database_sg.name
}