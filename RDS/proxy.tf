######################################################################################
## RDS Proxy
######################################################################################

resource "aws_db_proxy" "aurora_proxy" {
  name                   = "aurora-proxy"
  debug_logging          = true
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = false
  vpc_security_group_ids = ["sg-003566a47b586d4fa"]
  vpc_subnet_ids         = ["subnet-0573a5eb6ce26df41", "subnet-09619065c33d08027"]
  role_arn               = aws_iam_role.aurora_proxy_iam_role.arn

  #auth {
  #auth_scheme = "SECRETS"
  #description = "authenticate Aurora Proxy"
  ##iam_auth    = "DISABLED"
  #secret_arn  = data.aws_secretsmanager_secret.by-arn.arn
  #username =  jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.IDN_DB_USER.secret_string))["username"]
  #password = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.example_latest_password.secret_string))["password"]
  ## }
  auth {
    auth_scheme = "SECRETS"
    description = "authenticate Aurora Proxy"
    iam_auth    = "DISABLED"
    #secret_arn  = data.aws_secretsmanager_secret.by-arn.arn
    secret_arn = aws_secretsmanager_secret.aurora_secret.arn
  }


}
######################################################################################
## IAM
######################################################################################

#The IAM role that the proxy uses to access secrets in AWS Secrets Manager.

data "aws_iam_policy_document" "assume_role" {

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "aurora_proxy_policy_document" {

  statement {
    sid = "AllowProxyToGetDbCredsFromSecretsManager"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      aws_secretsmanager_secret.aurora_secret.arn #data.aws_secretsmanager_secret.by-arn.arn
    ]
  }

  statement {
    sid = "AllowProxyToDecryptDbCredsFromSecretsManager"
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "StringEquals"
      values   = ["secretsmanager.${var.region}.amazonaws.com"]
      variable = "kms:ViaService"
    }
  }
}


resource "aws_iam_policy" "aurora_proxy_iam_policy" {
  name   = "aurora-proxy-policy"
  policy = data.aws_iam_policy_document.aurora_proxy_policy_document.json
}

resource "aws_iam_role_policy_attachment" "aurora_proxy_iam_attach" {
  policy_arn = aws_iam_policy.aurora_proxy_iam_policy.arn
  role       = aws_iam_role.aurora_proxy_iam_role.name
}

resource "aws_iam_role" "aurora_proxy_iam_role" {
  name               = "aurora-post-proxy-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


#data "aws_secretsmanager_secret" "by-arn" {
#  name = "dev003_admin_user"
#}


######################################################################################
## Proxy Target
######################################################################################
# RDS Proxy Target Group

resource "aws_db_proxy_default_target_group" "aurora_proxy" {
  db_proxy_name = aws_db_proxy.aurora_proxy.name

  connection_pool_config {
    connection_borrow_timeout    = 120
    max_connections_percent      = 100
    max_idle_connections_percent = 50
  }
}

resource "aws_db_proxy_target" "aurora_db_cluster" {

  db_proxy_name         = aws_db_proxy.aurora_proxy.name
  target_group_name     = aws_db_proxy_default_target_group.aurora_proxy.name
  db_cluster_identifier = aws_rds_cluster.demo.id #aws_rds_cluster.aurora_cluster.id
}

resource "aws_db_proxy_target" "aurora_db_instance" {
  count = var.create_proxy && var.target_db_instance ? 1 : 0

  db_proxy_name          = aws_db_proxy.aurora_proxy.name
  target_group_name      = aws_db_proxy_default_target_group.aurora_proxy.name
  db_instance_identifier = aws_rds_cluster_instance.cluster_instance[count.index].id
}

######################################################################################
#End point
######################################################################################
#Endpoint will be used to connect to the application
resource "aws_db_proxy_endpoint" "aurora_proxy" {

  db_proxy_name          = aws_db_proxy.aurora_proxy.name
  db_proxy_endpoint_name = "aurora-proxy-endpoint"
  vpc_subnet_ids         = ["subnet-0573a5eb6ce26df41", "subnet-09619065c33d08027"]
  vpc_security_group_ids = ["sg-003566a47b586d4fa"]
  target_role            = "READ_ONLY"

}

######################################################################################
## CloudWatch Logs
######################################################################################

resource "aws_cloudwatch_log_group" "postgres_proxy" {

  name              = "aurora-proxy-cloudwatch"
  retention_in_days = 0

}
