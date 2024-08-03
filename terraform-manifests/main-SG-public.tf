## Main resource file for public security group
resource "aws_security_group" "public_sg" {
  vpc_id      = aws_vpc.main.id
  name        = "${local.name_prefix}-${var.public_sg_name}"
  description = var.public_sg_description
  dynamic "ingress" {
    for_each = var.public_sg_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = var.public_sg_egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
  tags = local.common_tags

}

## Public Security Group IDS
output "public_security_group" {
  description = "Public Security Group ID"
  value       = aws_security_group.public_sg.id
}
## Public Security Group Names
output "public_security_group_name" {
  description = "Public Security Group Name"
  value       = aws_security_group.public_sg.name
}