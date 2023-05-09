resource "aws_lambda_function" "my_function" {
  filename      = "../app.zip"
  function_name = "${var.function_name}-${var.env}"
  role          = aws_iam_role.my_role.arn
  handler       = "app.handler.lambda_handler"
  runtime       = "python3.9"

  source_code_hash = filebase64sha256("../app.zip")

  lifecycle {
    create_before_destroy = true
  }

  environment {
    variables = {
      db_name = "${var.db_name}-${var.function_name}-${var.env}"
      secret_name = "${var.secret_name}-${var.env}"
    }
  }
}

resource "aws_lambda_permission" "secretsmanager" {
  statement_id  = "AllowExecutionFromSecretsManager"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_function.function_name
  principal     = "secretsmanager.amazonaws.com"
}


resource "aws_iam_role" "my_role" {
  name = "replenish4me-${var.function_name}-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name = "secrets_manager_policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "secretsmanager:GetSecretValue",
            "secretsmanager:UpdateSecret"
          ]
          Resource = aws_secretsmanager_secret.db.arn
        }
      ]
    })
  }

  inline_policy {
    name = "rds_policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "rds:ModifyDBInstance"
          ]
          Resource = aws_db_instance.db.arn
        }
      ]
    })
  }

  inline_policy {
    name = "lambda_secrets_manager_policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = "secretsmanager:GetSecretValue"
          Resource = aws_secretsmanager_secret.db.arn
        }
      ]
    })
  }
}


resource "aws_iam_role_policy_attachment" "my_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.my_role.name
}
