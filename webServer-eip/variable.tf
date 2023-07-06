variable "aws_region" {
    type = string
  default = "us-east-1"  
}

variable "aws_ami" {
    type = string
    default = "ami-08e637cea2f053dfa"
}

variable "aws_instance_type" {
    type = string
    default = "t2.micro"
}

variable "sshport_ingress" {
    type = number
    default = [80,443]  
}

variable "sshport_egress" {
    type = number
    default = 0
  
}

