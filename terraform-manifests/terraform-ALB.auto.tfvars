## ALB Values
alb_values = {
  name                     = "application-lb"
  internal                 = false
  load_balancer_type       = "application"
  enable_delete_protection = false
}

## HTTP Listener Values
http_listener_values = {
  name     = "http-listener"
  port     = 80
  protocol = "HTTP"
  default_action = {
    target_type = "redirect"
    port        = 443
    protocol    = "HTTPS"
    status_code = "HTTP_301"
  }
}

## HTTPS Listener Values
https_listener_values = {
  name       = "https-listener"
  port       = 443
  protocol   = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  #ssl_certificate_arn = "dffdfg"
  default_action = {
    target_type = "forward"

  }
}
## ALB Target Group Values
alb_target_group_values = {
  name        = "alb-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"

  health_check = {
    enabled             = true
    port                = "traffic-port"
    protocol            = "HTTP"
    path                = "/index.html"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}
