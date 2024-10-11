resource "aws_sns_topic" "approval_notifications" {
  name = var.sns_topic_name
}


resource "aws_sns_topic_subscription" "approval_notifications_email" {
  topic_arn = aws_sns_topic.approval_notifications.arn
  protocol  = var.sns_protocol
  endpoint  = var.sns_endpoint
}
