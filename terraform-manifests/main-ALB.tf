## ALB Main Configuration
resource "aws_lb" "application_lb" {
  name                       = "${local.name_prefix}-${var.alb_values.name}"
  internal                   = var.alb_values.internal
  load_balancer_type         = var.alb_values.load_balancer_type
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = aws_subnet.public_subnet[*].id
  enable_deletion_protection = var.alb_values.enable_delete_protection
  tags                       = local.common_tags
}

## ALB Target Group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "${local.name_prefix}-${var.alb_target_group_values.name}"
  vpc_id      = aws_vpc.main.id
  port        = var.alb_target_group_values.port
  protocol    = var.alb_target_group_values.protocol
  target_type = var.alb_target_group_values.target_type

  health_check {
    enabled             = var.alb_target_group_values.health_check.enabled
    path                = var.alb_target_group_values.health_check.path
    port                = var.alb_target_group_values.health_check.port
    protocol            = var.alb_target_group_values.health_check.protocol
    interval            = var.alb_target_group_values.health_check.interval
    timeout             = var.alb_target_group_values.health_check.timeout
    healthy_threshold   = var.alb_target_group_values.health_check.healthy_threshold
    unhealthy_threshold = var.alb_target_group_values.health_check.unhealthy_threshold
    matcher             = var.alb_target_group_values.health_check.matcher
  }
  tags = local.common_tags

}

## ALB HTTP Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.application_lb.arn
  port              = var.http_listener_values.port
  protocol          = var.http_listener_values.protocol
  default_action {
    type = var.http_listener_values.default_action.target_type
    redirect {
      port        = var.http_listener_values.default_action.port
      protocol    = var.http_listener_values.default_action.protocol
      status_code = var.http_listener_values.default_action.status_code
    }
  }
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix}-http-listener"
    }
  )
}

## ALB HTTPS Listener
resource "aws_lb_listener" "https_listener" {
  depends_on        = [aws_acm_certificate.acm_certificate]
  load_balancer_arn = aws_lb.application_lb.arn
  port              = var.https_listener_values.port
  protocol          = var.https_listener_values.protocol
  certificate_arn   = aws_acm_certificate.acm_certificate.arn
  ssl_policy        = var.https_listener_values.ssl_policy
  default_action {
    type = var.https_listener_values.default_action.target_type
    forward {
      target_group {
        arn = aws_lb_target_group.alb_target_group.arn
      }
    }
  }
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix}-https-listener"
    }
  )
}


## ALB Target Group Attachment
resource "aws_lb_target_group_attachment" "ec2_attachment" {
  count            = length(aws_instance.private_ec2[*].id)
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = aws_instance.private_ec2[count.index].id
  #port             = 80
}

# resource "aws_lb_listener_rule" "listener_rule" {
#     listener_arn = aws_lb_listener.https_listener.arn
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb_target_group.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/*"]
#     }
#   }
# }

