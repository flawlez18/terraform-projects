


######################################################################
#DATA
######################################################################


data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_availability_zones" "available" {
  state = "available"
}

######################################################################
#RESOURCES
######################################################################

#NETWORKING

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = local.common_tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = local.common_tags

}

resource "aws_subnet" "subnets" {
  count                   = var.vpc_subnet_count
  cidr_block              = var.subnets_cidr_block[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = local.common_tags

}

# resource "aws_subnet" "subnet2" {
#   cidr_block              = var.subnets_cidr_block[1]
#   vpc_id                  = aws_vpc.vpc.id
#   map_public_ip_on_launch = var.map_public_ip_on_launch
#   availability_zone       = data.aws_availability_zones.available.names[1]

#   tags = local.common_tags

# }

#ROUTING

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "rta-subnets" {
  count          = var.aws_route_table_association_count
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.rtb.id
}

# resource "aws_route_table_association" "rta-subnet2" {
#   subnet_id      = aws_subnet.subnet2.id
#   route_table_id = aws_route_table.rtb.id
# }
#SECURITY GROUPS
#for Nginx security group

resource "aws_security_group" "nginx-sg" {
  name   = "nginx-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }


  tags = local.common_tags
}


resource "aws_security_group" "alb-sg" {
  name   = "nginx_alb_sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }


  tags = local.common_tags
}

