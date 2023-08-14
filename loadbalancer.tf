# Data Source 

#aws_elb_service_acount # Will give us serivice principal account for the elastic load balancer in the region we are currently working in and we can grant that access to the s3 bucket.
data "aws_elb_service_account" "root" {}


##aws_lb
resource "aws_lb" "nginx" {
  name               = "globo-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = aws_subnet.subnets[*].id

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.static_web.bucket
    prefix  = "alb-logs"
    enabled = true
  }

  tags = local.common_tags

}
##aws_lb_target_group
resource "aws_lb_target_group" "nginx" {
  name     = "globo-web-target-group"
  port     = 80     #maybe required
  protocol = "HTTP" #may be required
  vpc_id   = aws_vpc.vpc.id

  tags = local.common_tags
}

## aws_lb_listener

resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn


    #tags = local.common_tags

  }
}

##aws_lb_target_group_attachment
resource "aws_lb_target_group_attachment" "nginx" {
  count            = var.aws_lb_target_group_attachment_count
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.nginx[count.index].id
  port             = 80 #optional
}

# resource "aws_lb_target_group_attachment" "nginx2" {
#   target_group_arn = aws_lb_target_group.nginx.arn
#   target_id        = aws_instance.nginx2.id
#   port             = 80 #optional
#}