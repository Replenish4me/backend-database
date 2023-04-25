resource "random_password" "db_password" {
  length  = 16
  special = true
  min_lower   = 1
  min_numeric = 1
  min_special = 1
  min_upper   = 1
}

resource "aws_db_instance" "db" {
  identifier           = "${var.db_name}-${var.function_name}-${var.env}"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "${var.db_name}-${var.function_name}-${var.env}"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  username      = "admin"
  password      = random_password.db_password.result
}
