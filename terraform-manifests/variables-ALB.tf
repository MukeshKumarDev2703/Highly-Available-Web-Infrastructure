## ALB Values 
variable "alb_values" {
  description = "ALB Values"
  type = object({
    name                     = string
    internal                 = bool
    load_balancer_type       = string
    enable_delete_protection = bool
  })
}

## HTTP Listener Values
variable "http_listener_values" {
  description = "ALB Listener Values"
  type = object({
    name     = string
    port     = number
    protocol = string
    default_action = object({
      port        = number
      protocol    = string
      status_code = string
      target_type = string
    })
  })
}
## HTTPS Listener Values
variable "https_listener_values" {
  description = "ALB Listener Values"
  type = object({
    name       = string
    port       = number
    protocol   = string
    ssl_policy = string
    #ssl_certificate_arn = string
    default_action = object({
      target_type = string

    })

  })
}

## ALB Target Values
variable "alb_target_group_values" {
  description = "ALB Target values"
  type = object({
    name        = string
    port        = number
    protocol    = string
    target_type = string
    health_check = object({
      enabled             = bool
      path                = string
      port                = string
      protocol            = string
      interval            = number
      timeout             = number
      healthy_threshold   = number
      unhealthy_threshold = number
      matcher             = string
    })
  })
}
