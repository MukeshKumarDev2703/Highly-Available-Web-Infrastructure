## Public EC2 Instances Names
output "public_ec2_instance_names" {
  description = "List of names assigned to the public instances"
  value       = aws_instance.public_ec2[*].tags.Name
}

## Public EC2 Instance IDS
output "public_ec2_instance_id" {
  description = "List of IDs of instances"
  value       = aws_instance.public_ec2[*].id
}

## Public Ip address Of Public EC2 Instance
output "public_ip_of_public_ec2" {
  description = "List of public IP addresses assigned to the instances"
  value       = aws_instance.public_ec2[*].public_ip
}

## Public EC2 Instances Subnet Ids
output "public_ec2_subnet_ids" {
  description = "List of subnet IDs assigned to the instances"
  value       = aws_instance.public_ec2[*].subnet_id
}

## Public EC2 Instances Security Group Ids
output "public_ec2_security_group_ids" {
  description = "List of security group IDs assigned to the instances"
  value       = aws_instance.public_ec2[*].security_groups
}

## Private Ec2 Instances IDS
output "private_ec2_instance_ids" {
  description = "List of private Ec2 Instances IDs assigned to the instances"
  value       = aws_instance.private_ec2[*].id
}

## Private Ec2 Instances Names
output "private_ec2_instance_names" {
  description = "List of private EC2 Instances names assigned to the instances"
  value       = aws_instance.private_ec2[*].tags.Name
}
## Private Ec2 Instances Private IP Addresses
output "private_ec2_private_ip_addresses" {
  description = "List of private IP addresses assigned to the instances"
  value       = aws_instance.private_ec2[*].private_ip
}

## Private EC2 Instances Subnet Ids
output "private_ec2_subnet_ids" {
  description = "List of subnet IDs assigned to the instances"
  value       = aws_instance.private_ec2[*].subnet_id
}

## Private Ec2 Instances Security Group Ids
output "private_ec2_security_group_ids" {
  description = "List of security group IDs assigned to the instances"
  value       = aws_instance.private_ec2[*].security_groups
}


