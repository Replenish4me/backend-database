resource "aws_secretsmanager_secret" "db" {
  name = "replenish4me-db-password-${var.env}"

  rotation_lambda_arn = aws_lambda_function.my_function.arn

  rotation_rules {
    automatically_after_days = 1
  }
}