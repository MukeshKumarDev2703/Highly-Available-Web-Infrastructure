## Values for the Launch configuration
launch_config_values = {
  config_name         = "ec2_launch_config"
  instance_type       = "t3.micro"
  associate_public_ip = false
  storage = {
    root_block_device = {
      device_name           = null
      delete_on_termination = true
      encrypted             = true
      volume_size           = 15
      volume_type           = "gp2"
    }
    ebs_block_device = {
      device_name           = "/dev/xvdf"
      delete_on_termination = true
      encrypted             = true
      volume_size           = 20
      volume_type           = "gp2"
    }
  }
}

## ASG Values
asg_values = {
  asg_name          = "my-asg"
  desired_capacity  = 0
  min_size          = 0
  max_size          = 0
  health_check_type = "EC2"
  force_delete      = true
}