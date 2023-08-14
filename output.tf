#OUTPUT

output "public_ip" {
  value = aws_instance.nginx[*].public_ip
}

output "aws_instance_public_dns" {
  value = aws_instance.nginx[*].public_dns
}

output "alb_dns_name" {
  value = aws_lb.nginx.dns_name

}