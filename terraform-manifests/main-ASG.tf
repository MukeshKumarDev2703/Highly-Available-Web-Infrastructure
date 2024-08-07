
# ##  Autoscaling Launch Template
# resource "aws_launch_template" "ec2-launch-template" {
#   name_prefix = "${local.name_prefix}-ec2-launch-template"
#   image_id      = data.aws_ami.ubuntu_ami.id
#   instance_type = "t3.micro"
#   security_group_names = [aws_security_group.private_sg.name]
#   key_name = var.private_ec2.instance_keypair
#   user_data = file("${path.module}/server-1.sh")
#  lifecycle {
#    create_before_destroy = true
#  }
#  tags = local.common_tags
# }

##  Autoscaling Launch Configurations
resource "aws_launch_configuration" "ec2_launch_configuration" {
  name_prefix = "${local.name_prefix}-${var.launch_config_values.config_name}"

  image_id                    = data.aws_ami.ubuntu_ami.id
  instance_type               = var.launch_config_values.instance_type
  associate_public_ip_address = var.launch_config_values.associate_public_ip
  security_groups             = [aws_security_group.private_sg.id]
  key_name                    = var.private_ec2.instance_keypair
  user_data                   = file("${path.module}/server-1.sh")

  ## Root Block Device
  dynamic "root_block_device" {
    for_each = { for key, value in var.launch_config_values.storage : key => value if key == "root_block_device" }
    content {
      volume_size           = root_block_device.value.volume_size
      volume_type           = root_block_device.value.volume_type
      delete_on_termination = root_block_device.value.delete_on_termination
      encrypted             = root_block_device.value.encrypted
    }
  }
  ## Additional EBS Block Device
  dynamic "ebs_block_device" {
    for_each = { for key, value in var.launch_config_values.storage : key => value if key == "ebs_block_device" }
    content {
      device_name           = ebs_block_device.value.device_name
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = ebs_block_device.value.volume_type
      delete_on_termination = ebs_block_device.value.delete_on_termination
      encrypted             = ebs_block_device.value.encrypted
    }
  }
  lifecycle {
    create_before_destroy = true
  }

}

##  Autoscaling Group
resource "aws_autoscaling_group" "autoscaling_group" {
  name                 = "${local.name_prefix}-${var.asg_values.asg_name}"
  launch_configuration = aws_launch_configuration.ec2_launch_configuration.id
  #availability_zones   = data.aws_availability_zones.available_zones.names
  vpc_zone_identifier = aws_subnet.private_subnet[*].id
  min_size            = var.asg_values.min_size
  max_size            = var.asg_values.max_size
  desired_capacity    = var.asg_values.desired_capacity
  health_check_type   = var.asg_values.health_check_type
  force_delete        = var.asg_values.force_delete
  target_group_arns   = [aws_lb_target_group.alb_target_group.arn]
  lifecycle {

    create_before_destroy = true
  }
  tag {
    key                 = "owner"
    value               = local.owner
    propagate_at_launch = true
  }
}

## Autoscaling policy Based on CPU Utilization of EC2
resource "aws_autoscaling_policy" "avg_cpu_policy_greater_than_xx" {
  name                      = "${local.name_prefix}-avg-cpu-policy-greater-than-xx"
  autoscaling_group_name    = aws_autoscaling_group.autoscaling_group.name
  estimated_instance_warmup = 180
  policy_type               = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"

    }
    target_value = 50.0
  }
}

## Autoscaling Policy Based on Alb target Request

resource "aws_autoscaling_policy" "alb_target_request_greater_then_yy" {
  depends_on = [ aws_lb_listener.https_listener ]
  name                      = "${local.name_prefix}-alb-target-request-greater-then-yy"
  autoscaling_group_name    = aws_autoscaling_group.autoscaling_group.name
  estimated_instance_warmup = 120
  policy_type               = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${aws_lb.application_lb.arn_suffix}/${aws_lb_target_group.alb_target_group.arn_suffix}"
    }
    target_value = 10.0
  }
}

## Autoscaling Lifecycle Hook
resource "aws_autoscaling_lifecycle_hook" "launch_hook" {
  name                   = "${local.name_prefix}-launch_hook"
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
  default_result         = "CONTINUE"
  heartbeat_timeout      = 60
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"

  notification_metadata = jsonencode({
    Hello = "World"
  })

  notification_target_arn = aws_sns_topic.myasg_sns_topic.arn
  role_arn                = aws_iam_role.autoscaling_role.arn
}

resource "aws_autoscaling_lifecycle_hook" "termination_hook" {
  name                   = "${local.name_prefix}-termination_hook"
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
  default_result         = "CONTINUE"
  heartbeat_timeout      = 180
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"

  notification_metadata = jsonencode({
    Goodbye = "World"
  })

  notification_target_arn = aws_sns_topic.myasg_sns_topic.arn
  role_arn                = aws_iam_role.autoscaling_role.arn
}

## SNS - Topic
resource "aws_sns_topic" "myasg_sns_topic" {
  name = "${local.name_prefix}-myasg-sns-topic"
  tags = local.common_tags
}

## SNS - Subscription

resource "aws_sns_topic_subscription" "myasg_sns_topic_subscription" {
  topic_arn = aws_sns_topic.myasg_sns_topic.arn
  protocol  = "email"
  endpoint  = "mukeshinfra03@gmail.com"
}



## Create Autoscaling Notification Resource
resource "aws_autoscaling_notification" "myasg_notifications" {
  group_names = [aws_autoscaling_group.autoscaling_group.name]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]
  topic_arn = aws_sns_topic.myasg_sns_topic.arn
}


# IAM Role
resource "aws_iam_role" "autoscaling_role" {
  name = "${local.name_prefix}-autoscaling_notification_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "autoscaling.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = local.common_tags
}

# IAM Policy
resource "aws_iam_policy" "autoscaling_policy" {
  name        = "${local.name_prefix}-autoscaling_notification_policy"
  description = "Policy to allow Auto Scaling to send notifications"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish", # Use "sqs:SendMessage" if using SQS
        ]
        Resource = [
          aws_sns_topic.myasg_sns_topic.arn,
        ]
      }
    ]
  })
  tags = local.common_tags
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "autoscaling_policy_attachment" {
  role       = aws_iam_role.autoscaling_role.name
  policy_arn = aws_iam_policy.autoscaling_policy.arn
}

