provider "aws" {
    region = "var.aws_region"
    }

resource "aws_instance" "webServer" {
  ami = "var.aws_ami"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.webServer.name]

  tags = local.common_tags
}

resource "aws_eip" "elasticip" {
  instance = aws_instance.webServer.id
  vpc      = true
}

output "eip" {
    value = aws_eip.elasticip.public_ip
}

# declare ingress variable
variable "ingressrules" {
  type = list(number)
  default = var.sshport_ingress
}

# declare egress variable
variable "egressrules" {
  type = list(number)
  default = var.sshport_egress
}

resource "aws_security_group" "webServer" {
   name = "Allow HTTPS"

   ingress{
     from_port =80
     to_port = 80
     protocol = "TCP"
     cidr_block = ["0.0.0.0/0"]
   }

   egress {
     from_port = 0
     to_port = 0
     protocol = "TCP"
     cidr_block = ["0.0.0.0/0"]
   }                                                                        
}

