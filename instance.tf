#INSTANCES

resource "aws_instance" "nginx" {
  count                  = var.aws_instance_count
  depends_on             = [aws_iam_role_policy.allw_s3_all]
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name


  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
aws s3 cp s3://${aws_s3_bucket.static_web.id}/website/index.html /home/ec2-user/index.html
aws s3 cp s3://${aws_s3_bucket.static_web.id}/website/Globo_logo_Vert.png /home/ec2-user/Globo_logo_Vert.png
sudo rm /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/Globo_logo_Vert.png /usr/share/nginx/html/Globo_logo_Vert.png
EOF

  tags = local.common_tags
}

# resource "aws_instance" "nginx2" {
#   depends_on             = [aws_iam_role_policy.allw_s3_all]
#   ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
#   instance_type          = var.instance_type
#   subnet_id              = aws_subnet.subnet2.id
#   vpc_security_group_ids = [aws_security_group.nginx-sg.id]
#   iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name

#   user_data = <<EOF
# #! /bin/bash
# sudo amazon-linux-extras install -y nginx1
# sudo service nginx start
# aws s3 cp s3://${aws_s3_bucket.static_web.id}/website/index.html /home/ec2-user/index.html
# aws s3 cp s3://${aws_s3_bucket.static_web.id}/website/Globo_logo_Vert.png /home/ec2-user/Globo_logo_Vert.png
# sudo rm /usr/share/nginx/html/index.html
# sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
# sudo cp /home/ec2-user/Globo_logo_Vert.png /usr/share/nginx/html/Globo_logo_Vert.png
# EOF

#   tags = local.common_tags
# }
