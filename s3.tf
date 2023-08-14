##s3 Resources

#aws_s3_bucket #S3 bucket itself
resource "aws_s3_bucket" "static_web" {
  bucket        = local.s3_bucket_name
  acl           = "private"
  force_destroy = true

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_elb_service_account.root.arn}"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}/alb-logs/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${local.s3_bucket_name}"
    }
  ]
}
    POLICY

  tags = local.common_tags
}



#"aws_s3_bucket_object" object in the bucket
resource "aws_s3_bucket_object" "website" {
  for_each = {
    "website" = "/website/index"
    "logo" = "/website/Globo_logo_Vert.png"
  }
  bucket = "static-web"
  key    = each.value
  source = ".${each.value}"

  tags = local.common_tags

}

# resource "aws_s3_bucket_object" "graphic" {
#   bucket = "static-web"
#   key    = "/website/Globo_logo_Vert.png"
#   source = "./website/Globo_logo_Vert.png"

#   tags = local.common_tags

# }


#aws_iam_role #- Role for instances  
resource "aws_iam_role" "allow_nginx_s3" {
  name = "allow_nginx_s3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = local.common_tags

}

# aws_iam_role_policy #- Role for S3 access 
resource "aws_iam_role_policy" "allw_s3_all" {
  name = "allw_s3_all"
  role = aws_iam_role.allow_nginx_s3.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        #Resource = "*"
        Resource = [
          "arn:aws:s3:::${local.s3_bucket_name}",
          "arn:aws:s3:::${local.s3_bucket_name}/*"

        ]
      },
    ]
  })
}
## aws_iam_instance_profile # - Instance profile will be used to assign role to aws instance
resource "aws_iam_instance_profile" "nginx_profile" {
  name = "nginx_profile"
  role = aws_iam_role.allow_nginx_s3.name

  tags = local.common_tags
}
