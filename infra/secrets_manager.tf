resource "aws_secretsmanager_secret" "db" {
  name = "${var.secret_name}-${var.env}"
}

resource "aws_secretsmanager_secret_rotation" "db" {
  secret_id = aws_secretsmanager_secret.db.id

  rotation_lambda_arn = aws_lambda_function.my_function.arn

  rotation_rules {
    automatically_after_days = 1
  }
}