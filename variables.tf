variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnets_cidr_block" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "map_public_ip_on_launch" {
  type    = bool
  default = true
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
}


variable "billing_code" {
  type    = string
  default = ""
}

variable "company" {
  type    = string
  default = "Globomantics"
}


variable "vpc_subnet_count" {
  type        = number
  description = "Number of subnets to create"
  default     = 2
}
variable "aws_route_table_association_count" {
  type    = number
  default = 2
}

variable "aws_instance_count" {
  type    = number
  default = 2
}

variable "aws_lb_target_group_attachment_count" {
  type = number
  default = 2
}