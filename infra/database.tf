resource "aws_db_instance" "db" {
  identifier           = "${var.db_name}-${var.function_name}-${var.env}"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "${var.db_name}-${var.function_name}-${var.env}"
  username             = "admin"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}
