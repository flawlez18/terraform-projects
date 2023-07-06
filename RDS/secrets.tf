# ######################################################################################
# ## aws secret manager
# ######################################################################################
# #secrets that will be used to access the database

resource "aws_secretsmanager_secret_version" "aurora_secret_version" {
  secret_id = aws_secretsmanager_secret.aurora_secret.id
  secret_string = jsonencode({
    "username"            = "admin"
    "password"            = "admin123"
    "engine"              = "mysql"
    "host"                = aws_rds_cluster.demo.endpoint
    "port"                = 3306
    "dbClusterIdentifier" = aws_rds_cluster.demo.id #aws_rds_cluster.aurora_cluster.id
    #"dbInstanceIdentifier" = "mysql-proxy-db"
  })
}

resource "aws_secretsmanager_secret" "aurora_secret" {
  name_prefix             = "aurora-proxy-secret"
  recovery_window_in_days = 7
  description             = "Secret for Aurora Proxy"
}





# data "aws_secretsmanager_secret" "by_password" {
#   name = "rds-password"
# }

# # #data.aws_secretsmanager_secret.secrets.id
# data "aws_secretsmanager_secret_version" "example_latest_password" {
#   secret_id = data.aws_secretsmanager_secret.by_password.id
#   secret_arn = data.aws_secretsmanager_secret.by_password.arn
# }

# output "sensitive_example_password" {
#   value     = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.example_latest_password.secret_string))["password"]
# }

# data "aws_secretsmanager_secret" "IDN_DB_USER" {
#   name = "rds-username"
# }



# # #data.aws_secretsmanager_secret.secrets.id
# data "aws_secretsmanager_secret_version" "IDN_DB_USER" {
#   secret_id = data.aws_secretsmanager_secret.by_username_1.id
# }


# output "sensitive_example_hash" {
#   value     = jsondecode(nonsensitive(data.aws_secretsmanager_secret_version.example_latest_ver.secret_string))["username"]
# }






























# ######################################################################################
# ## aws secret manager
# ######################################################################################
# #secrets that will be used to access the database

# resource "aws_secretsmanager_secret_version" "aurora_secret_version" {
#   secret_id = aws_secretsmanager_secret.aurora_admin.id
#   secret_string = jsonencode({
#     "username"            = admin     
#     "password"            = admin123
#     "engine"              = "mysql"
#     "host"                = aws_rds_cluster.aurora_cluster.endpoint
#     "port"                = 3306
#     "dbClusterIdentifier" = aws_rds_cluster.demo.id 
#   })
# }

# resource "aws_secretsmanager_secret" "aurora_admin" {
#   name_prefix             = "aurora-admin-proxy-secret"
#   recovery_window_in_days = 7
#   description             = "Secret for Aurora Proxy"
# }

# resource "aws_secretsmanager_secret_version" "aurora_secret_dev_PRE_DB" {
#   secret_id = aws_secretsmanager_secret.aurora_dev_PRE_DB.id
#   secret_string = jsonencode({
#     "username"            = dev_PRE_DB_USER     
#     "password"            = dev_PRE_DB_PWD
#     "engine"              = "mysql"
#     "host"                = aws_rds_cluster.aurora_cluster.endpoint
#     "port"                = 3306
#     "dbClusterIdentifier" = aws_rds_cluster.demo.id 
#   })
# }

# resource "aws_secretsmanager_secret" "aurora_dev_PRE_DB" {
#   name_prefix             = "aurora-dev-PRE-DB-proxy-secret"
#   recovery_window_in_days = 7
#   description             = "Secret for Aurora Proxy"
# }

# resource "aws_secretsmanager_secret_version" "aurora_secret_dev_PRO_DB" {
#   secret_id = aws_secretsmanager_secret.aurora_dev_PRO_DB.id
#   secret_string = jsonencode({
#     "username"            = dev_PRO_DB_USER     
#     "password"            = dev_PRO_DB_PWD
#     "engine"              = "mysql"
#     "host"                = aws_rds_cluster.aurora_cluster.endpoint
#     "port"                = 3306
#     "dbClusterIdentifier" = aws_rds_cluster.demo.id 
#   })
# }

# resource "aws_secretsmanager_secret" "aurora_dev_PRO_DB" {
#   name_prefix             = "aurora-dev-PRO-DB-proxy-secret"
#   recovery_window_in_days = 7
#   description             = "Secret for Aurora Proxy"
# }

# resource "aws_secretsmanager_secret_version" "aurora_secret_dev_DEXCHANGE_DB" {
#   secret_id = aws_secretsmanager_secret.aurora_dev_DEXCHANGE_DB.id
#   secret_string = jsonencode({
#     "username"            = dev_DEXCHANGE_DB_USER     
#     "password"            = dev_DEXCHANGE_DB_PWD
#     "engine"              = "mysql"
#     "host"                = aws_rds_cluster.aurora_cluster.endpoint
#     "port"                = 3306
#     "dbClusterIdentifier" = aws_rds_cluster.demo.id 
#   })
# }

# resource "aws_secretsmanager_secret" "aurora_dev_DEXCHANGE_DB" {
#   name_prefix             = "aurora-dev-DEXCHANGE-DB-proxy-secret"
#   recovery_window_in_days = 7
#   description             = "Secret for Aurora Proxy"
# }

# resource "aws_secretsmanager_secret_version" "aurora_secret_dev_AUTH_DB" {
#   secret_id = aws_secretsmanager_secret.aurora_dev_AUTH_DB.id
#   secret_string = jsonencode({
#     "username"            = dev_AUTH_DB_USER     
#     "password"            = dev_AUTH_DB_PWD
#     "engine"              = "mysql"
#     "host"                = aws_rds_cluster.aurora_cluster.endpoint
#     "port"                = 3306
#     "dbClusterIdentifier" = aws_rds_cluster.demo.id 
#   })
# }

# resource "aws_secretsmanager_secret" "aurora_dev_AUTH_DB" {
#   name_prefix             = "aurora-dev-AUTH-DB-proxy-secret"
#   recovery_window_in_days = 7
#   description             = "Secret for Aurora Proxy"
# }

# resource "aws_secretsmanager_secret_version" "aurora_secret_dev_IDN_DB" {
#   secret_id = aws_secretsmanager_secret.aurora_dev_IDN_DB.id
#   secret_string = jsonencode({
#     "username"            = dev_IDN_DB_USER     
#     "password"            = dev_IDN_DB_PWD
#     "engine"              = "mysql"
#     "host"                = aws_rds_cluster.aurora_cluster.endpoint
#     "port"                = 3306
#     "dbClusterIdentifier" = aws_rds_cluster.demo.id 
#   })
# }

# resource "aws_secretsmanager_secret" "aurora_dev_IDN_DB" {
#   name_prefix             = "aurora-dev-IDN-DB-proxy-secret"
#   recovery_window_in_days = 7
#   description             = "Secret for Aurora Proxy"
# }

# resource "aws_secretsmanager_secret_version" "aurora_secret_dev_SSTORAGE_DB" {
#   secret_id = aws_secretsmanager_secret.aurora_dev_SSTORAGE_DB.id
#   secret_string = jsonencode({
#     "username"            = dev_SSTORAGE_DB_USER     
#     "password"            = dev_SSTORAGE_DB_PWD
#     "engine"              = "mysql"
#     "host"                = aws_rds_cluster.aurora_cluster.endpoint
#     "port"                = 3306
#     "dbClusterIdentifier" = aws_rds_cluster.demo.id 
#   })
# }

# resource "aws_secretsmanager_secret" "aurora_dev_SSTORAGE_DB" {
#   name_prefix             = "aurora-dev-SSTORAGE-DB-proxy-secret"
#   recovery_window_in_days = 7
#   description             = "Secret for Aurora Proxy"
# }

# resource "aws_secretsmanager_secret_version" "aurora_secret_dev_UDDD_DB" {
#   secret_id = aws_secretsmanager_secret.aurora_dev_UDDD_DB.id
#   secret_string = jsonencode({
#     "username"            = dev_UDDD_DB_USER     
#     "password"            = dev_UDDD_DB_PWD
#     "engine"              = "mysql"
#     "host"                = aws_rds_cluster.aurora_cluster.endpoint
#     "port"                = 3306
#     "dbClusterIdentifier" = aws_rds_cluster.demo.id
#   })
# }

# resource "aws_secretsmanager_secret" "aurora_dev_UDDD_DB" {
#   name_prefix             = "aurora-dev-UDDD-DB-proxy-secret"
#   recovery_window_in_days = 7
#   description             = "Secret for Aurora Proxy"
# }

# resource "aws_secretsmanager_secret_version" "aurora_secret_dev_QBO_DB" {
#   secret_id = aws_secretsmanager_secret.aurora_dev_QBO_DB.id
#   secret_string = jsonencode({
#     "username"            = dev_QBO_DB_USER     
#     "password"            = dev_QBO_DB_PWD
#     "engine"              = "mysql"
#     "host"                = aws_rds_cluster.aurora_cluster.endpoint
#     "port"                = 3306
#     "dbClusterIdentifier" = aws_rds_cluster.demo.id 
#   })
# }

# resource "aws_secretsmanager_secret" "aurora_dev_QBO_DB" {
#   name_prefix             = "aurora-dev-QBO-DB-proxy-secret"
#   recovery_window_in_days = 7
#   description             = "Secret for Aurora Proxy"
# }

# resource "aws_secretsmanager_secret_version" "aurora_secret_dev_FILE_DB" {
#   secret_id = aws_secretsmanager_secret.aurora_dev_FILE_DB.id
#   secret_string = jsonencode({
#     "username"            = dev_FILE_DB_USER     
#     "password"            = dev_FILE_DB_PWD
#     "engine"              = "mysql"
#     "host"                = aws_rds_cluster.aurora_cluster.endpoint
#     "port"                = 3306
#     "dbClusterIdentifier" = aws_rds_cluster.demo.id
#   })
# }

# resource "aws_secretsmanager_secret" "aurora_dev_FILE_DB" {
#   name_prefix             = "aurora-dev-FILE-DB-proxy-secret"
#   recovery_window_in_days = 7
#   description             = "Secret for Aurora Proxy"
# }

# resource "aws_secretsmanager_secret_version" "aurora_secret_dev_ROYALTY_DB" {
#   secret_id = aws_secretsmanager_secret.aurora_dev_ROYALTY_DB.id
#   secret_string = jsonencode({
#     "username"            = dev_ROYALTY_DB_USER     
#     "password"            = dev_ROYALTY_DB_PWD
#     "engine"              = "mysql"
#     "host"                = aws_rds_cluster.aurora_cluster.endpoint
#     "port"                = 3306
#     "dbClusterIdentifier" = aws_rds_cluster.demo.id 
#   })
# }

# resource "aws_secretsmanager_secret" "aurora_dev_ROYALTY_DB" {
#   name_prefix             = "aurora-dev-ROYALTY-DB-proxy-secret"
#   recovery_window_in_days = 7
#   description             = "Secret for Aurora Proxy"
# }




