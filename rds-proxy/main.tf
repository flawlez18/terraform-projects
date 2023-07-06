resource "aws_db_proxy" "rds_proxy" {
  name                   = "rds_proxy"
  debug_logging          = false
  engine_family          = "MYSQL"
  idle_client_timeout    = 1800
  require_tls            = true
  role_arn               = aws_iam_role.example.arn
  vpc_security_group_ids = ["sg-003566a47b586d4fa"]
  vpc_subnet_ids         = ["vpc-03566b8bd70a46013"]

  auth {
    auth_scheme = "SECRETS"
    description = "authenticate RDS Proxy"
    iam_auth    = "DISABLED"
    secret_arn  = "arn:aws:secretsmanager:us-east-1:577456190159:secret:mysql-creds-fEWMmi"
  }

  tags = {
    Name = "example"
    Key  = "value"
  }
}

resource "aws_db_proxy_default_target_group" "rds_proxy" {


  db_proxy_name = aws_db_proxy.rds_proxy.name

  connection_pool_config {
    connection_borrow_timeout    = 120
    init_query                   = var.init_query
    max_connections_percent      = 100
    max_idle_connections_percent = 50
    session_pinning_filters      = ["EXCLUDE_VARIABLE_SETS"]
  }
}
resource "aws_db_proxy_target" "db_cluster" {
  
  db_proxy_name         = aws_db_proxy.rds_proxy.name
  target_group_name     = aws_db_proxy_default_target_group.rds_proxy.name
  db_cluster_identifier = var.db_cluster_identifier
}
data "aws_iam_policy_document" "assume_role" {
  count = var.create_proxy && var.create_iam_role ? 1 : 0

  statement {
    sid     = "RDSAssume"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "pro" {
  count = var.create_proxy && var.create_iam_role ? 1 : 0

  name        = var.use_role_name_prefix ? null : local.role_name
  name_prefix = var.use_role_name_prefix ? "${local.role_name}-" : null
  description = var.iam_role_description
  path        = var.iam_role_path

  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json
  force_detach_policies = var.iam_role_force_detach_policies
  max_session_duration  = var.iam_role_max_session_duration
  permissions_boundary  = var.iam_role_permissions_boundary

  tags = merge(var.tags, var.iam_role_tags)
}

data "aws_iam_policy_document" "this" {
  count = var.create_proxy && var.create_iam_role ? 1 : 0

  statement {
    sid       = "DecryptSecrets"
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = distinct([for secret in var.secrets : secret.kms_key_id])
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"

      values = [
        "secretsmanager.${data.aws_region.current.name}.amazonaws.com"
      ]
    }
  }

  statement {
    sid    = "ListSecrets"
    effect = "Allow"
    actions = [
      "secretsmanager:GetRandomPassword",
      "secretsmanager:ListSecrets",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "GetSecrets"
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
    ]

    resources = distinct([for secret in var.secrets : secret.arn])
  }
}

resource "aws_iam_role_policy" "this" {
  count = var.create_proxy && var.create_iam_role && var.create_iam_policy ? 1 : 0

  name        = var.use_policy_name_prefix ? null : local.policy_name
  name_prefix = var.use_policy_name_prefix ? "${local.policy_name}-" : null
  policy      = data.aws_iam_policy_document.this[0].json
  role        = aws_iam_role.this[0].id
}
