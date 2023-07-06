data "aws_secretsmanager_secret" "by_password" {
  name = "rds-password"
}



# #data.aws_secretsmanager_secret.secrets.id
data "aws_secretsmanager_secret_version" "example_latest_password" {
  secret_id = data.aws_secretsmanager_secret.by_password.id
}


output "sensitive_example_password" {
  value     = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.example_latest_password.secret_string))["password"]
}

data "aws_secretsmanager_secret" "by_username" {
  name = "rds-username"
}



# #data.aws_secretsmanager_secret.secrets.id
data "aws_secretsmanager_secret_version" "example_latest_ver" {
  secret_id = data.aws_secretsmanager_secret.by_username.id
}


output "sensitive_example_hash" {
  value     = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.example_latest_ver.secret_string))["username"]
}
