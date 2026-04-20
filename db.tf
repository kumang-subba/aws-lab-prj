resource "aws_db_instance" "mysql" {
  identifier             = "mydb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "<REDACTED>"
  username               = "<REDACTED>"
  password               = "<REDACTED>"
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  multi_az               = false
  skip_final_snapshot    = true
  monitoring_interval    = 0
  tags = {
    Name = "mysql-db"
  }
}
