## Output for VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

## Output for Public Subnet IDs
output "vpc_public_subnets" {
  description = "The Public Subnets"
  value       = aws_subnet.public_subnet[*].id
}

## Output for Private Subnet IDs
output "vpc_private_subnets" {
  description = "The Private Subnets"
  value       = aws_subnet.private_subnet[*].id
}

## Output for Database Subnets IDs
output "vpc_database_subnets" {
  description = "The Database Subnets"
  value       = aws_subnet.database_subnet[*].id
}

## Output for Nat Gateway ID
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.nat_gateway.id
}

## Output for Elastic ID
output "nat_eip" {
  description = "The Elastic IP for the NAT Gateway"
  value       = aws_eip.eip_nat.id
}

