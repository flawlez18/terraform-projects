# Create EC2 instance
resource "aws_instance" "webServer" {
  ami = "ami-06640050dc3f556bb"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.webServer.name]
  user_data = file("${path.module}/app1-install.sh")

  tags = {
    Name = "webServer"
  }
}

resource
# create elastic IP
resource "aws_eip" "elasticip" {
  instance = aws_instance.webServer.id
  vpc      = true
}

# create security group
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

