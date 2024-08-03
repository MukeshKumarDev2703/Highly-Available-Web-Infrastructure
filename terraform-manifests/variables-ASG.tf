## Variable for Launch Configuration Name
variable "launch_config_values" {
  description = "Name of the launch configuration"
  type = object({
    config_name         = string
    instance_type       = string
    associate_public_ip = bool
    storage = map(object({
      device_name           = string
      delete_on_termination = bool
      encrypted             = bool
      volume_size           = number
      volume_type           = string
    }))
  })
}

## Variable for Autoscaling group
variable "asg_values" {
  description = "Values fot ASG"
  type = object({
    asg_name          = string
    desired_capacity  = number
    min_size          = number
    max_size          = number
    health_check_type = string
    force_delete      = bool
  })
}