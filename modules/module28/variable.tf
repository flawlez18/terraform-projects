
#variable "instance_type" {
    #type = string
    #default = "t2.micro"
#}


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