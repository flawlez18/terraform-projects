provider "aws" {
  region = "us-east-1"
}


resource "aws_rds_proxy" "example" {
  name                      = "exampleproxy"
  debug_logging             = true
  engine_family             = "MYSQL"
  idle_client_timeout       = 1800
  require_tls               = true
  require_tls_supported_ciphers = ["AES256-SHA"]

  auth {
    username = "tf_user"
    password = "tf_password"
  }

  role_arn  = aws_iam_role.example.arn
  vpc_security_group_ids = [aws_security_group.example.id]
}

resource "aws_iam_role" "example" {
  name = "TF-proxy"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}

resource "aws_security_group" "example" {
  name = "TF-rds-proxy-example"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}