provider "aws"{
    region = "us-east-1"
    }

resource "aws_instance" "webServer" {
  ami = "ami-08e637cea2f053dfa"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.webServer.name]
   user_data = file("${path.module}/app1-install.sh")

  tags = {
    Name = "webServer"
  }
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
  default = [80,443]
}

# declare egress variable
variable "egressrules" {
  type = list(number)
  default = [80,443]
}

resource "aws_security_group" "webServer" {
   name = "Allow HTTPS"

   dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content{
      from_port = port.value
      to_port = port.value
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }    
   }

   dynamic "egress" {
     iterator = port
    for_each = var.egressrules
    content{
      from_port = port.value
      to_port = port.value
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }    
   } 
}

