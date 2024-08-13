name_prefix = "Stag-env"

## Environment Variable
environment = "Stag"


##VPC Values
aws_region = "ap-south-1"

vpc_name = "vpc"

map_public_ip = true

vpc_cidr_block = "10.0.0.0/16"

vpc_availability_zones = ["ap-south-1a", "ap-south-1b"]

vpc_public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

vpc_private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

vpc_db_subnets = ["10.0.151.0/24", "10.0.152.0/24"]


## Public Ec2 Values
public_ec2 = {
  name             = "public-ec2"
  instance_count   = 1
  instance_type    = "t2.micro"
  instance_keypair = "terraform-key"
  root_block_device = {
    volume_size = 8
    volume_type = "gp3"
    iops        = 3000
    throughput  = 125
  }
}

## Private Ec2 Values
private_ec2 = {
  name             = "private-ec2"
  instance_count   = 2
  instance_type    = "t2.micro"
  instance_keypair = "terraform-key"
  root_block_device = {
    volume_size = 8
    volume_type = "gp3"
    iops        = 3000
    throughput  = 125

} }

## DNS Name
domain_name = "stag.gotechworld.solutions"