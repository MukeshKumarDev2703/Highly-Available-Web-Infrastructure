## Database Values
db_instance_values = [{
  db_allocated_storage = 20
  db_instance_class    = "db.t3.micro"
  db_engine            = "mysql"
  db_engine_version    = "8.0.35"
  db_engine_identifier = "my-identifier"
  }
]

## Database configuration
db_config = {
  multi_az            = true
  publicly_accessible = false
  storage_encrypted   = true
  skip_final_snapshot = true
}

db_username = "admin"
db_password = "securepassword"
