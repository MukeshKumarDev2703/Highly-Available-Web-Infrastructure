## Variable for all ec2 instances

## Variable for Public Ec2 Values
variable "public_ec2" {
  description = "Values for Public Instance"
  type = object({
    name             = string
    instance_count   = number
    instance_type    = string
    instance_keypair = string
    root_block_device = object({
      volume_size = number
      volume_type = string
      iops        = number
      throughput  = number
    })

  })
}

## Vriable for Private Ec2 Values
variable "private_ec2" {
  description = "Values for Public Instance"
  type = object({
    name             = string
    instance_count   = number
    instance_type    = string
    instance_keypair = string
    root_block_device = object({
      volume_size = number
      volume_type = string
      iops        = number
      throughput  = number
    })
  })
}

## Variable for User Data Files
variable "user_data_file" {
  description = "Files for the user Data"
  type        = list(string)
}