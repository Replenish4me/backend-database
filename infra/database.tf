resource "aws_db_instance" "db" {
  identifier           = "replenish4me-${var.function_name}-${var.env}"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "replenish4me-${var.function_name}-role-${var.env}"
  username             = "admin"
  password             = "${aws_secretsmanager_secret_version.example.secret_string}"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}
