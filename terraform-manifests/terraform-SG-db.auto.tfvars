database_sg_name = "database-security-group"

database_sg_description = "This security group for my Database server"

database_sg_ingress_rules = [{
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}]

database_sg_egress_rules = [{
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}]