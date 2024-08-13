## Main Configuration for the Database instance.
resource "aws_db_instance" "db_instance" {

  instance_class         = var.db_instance_values[0].db_instance_class
  allocated_storage      = var.db_instance_values[0].db_allocated_storage
  engine                 = var.db_instance_values[0].db_engine
  engine_version         = var.db_instance_values[0].db_engine_version
  #identifier             = var.db_instance_values[0].db_engine_identifier
  identifier = var.db_engine_identifier
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  availability_zone      = data.aws_availability_zones.available_zones.names[0]


  #  multi_az            = var.db_config[0].multi_az
  storage_encrypted   = var.db_config.storage_encrypted
  publicly_accessible = var.db_config.publicly_accessible
  skip_final_snapshot = var.db_config.skip_final_snapshot
}
