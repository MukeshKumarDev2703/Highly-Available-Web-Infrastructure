## Route53 Hosted zonne
# resource "aws_route53_zone" "route53_zone" {
#   name = var.domain_name

# }
data "aws_route53_zone" "mydomain" {
  name = "gotechworld.solutions"
}

## ACM Certificate
resource "aws_acm_certificate" "acm_certificate" {
  domain_name       = trimsuffix(data.aws_route53_zone.mydomain.name, ".")
  validation_method = "DNS"
  subject_alternative_names = [
    "var.domain_name"
  ]
  lifecycle {

    create_before_destroy = true
  }
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix}-ACM-Certificate"
    }
  )
}

resource "aws_acm_certificate_validation" "validation" {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn] #[for option in aws_acm_certificate.acm_certificate.domain_validation_options : option.resource_record_name]
  depends_on = [aws_acm_certificate.acm_certificate,
  aws_route53_record.validation]
}

## Route53 Record Set
resource "aws_route53_record" "route53_record" {
  zone_id = data.aws_route53_zone.mydomain.id
  name    = "www.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_lb.application_lb.dns_name
    zone_id                = aws_lb.application_lb.zone_id
    evaluate_target_health = true
  }

}

##Validations for Alternative Names
resource "aws_route53_record" "validation" {
  for_each = {
    for option in aws_acm_certificate.acm_certificate.domain_validation_options :
    option.domain_name => {

      name  = option.resource_record_name
      type  = option.resource_record_type
      value = option.resource_record_value
    }
  }
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.mydomain.id
  name            = each.value.name
  type            = each.value.type
  ttl             = 60
  records         = [each.value.value]
  lifecycle {
    create_before_destroy = true

  }
}

