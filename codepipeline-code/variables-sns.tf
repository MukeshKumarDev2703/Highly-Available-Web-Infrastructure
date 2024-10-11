## This variable is used for Name of SNS Topic.
variable "sns_topic_name" {
  type    = string
  default = "approval-notifications"
}

## This variable for Email Endpoint. 
variable "sns_endpoint" {
  type    = string
  default = "kumarmukesh86996@gmail.com"
}

## This variable for sns Protocol. 
variable "sns_protocol" {
  type    = string
  default = "email"
}