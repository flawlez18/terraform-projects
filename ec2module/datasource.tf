# data "aws_ami" "ubuntu" {
#     most_recent = true
#     #owners = ["099720109477"]
#      owners = ["self"]

#     filter {
#         name = "name"
#         values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#     }

#     filter {
#         name = "root-device-type"
#         values = ["ebs"]
#     }

#     filter {
#         name = "virtualization-type"
#         values = ["hvm"]
#     }

#     filter {
#         name = "architecture"
#         values = ["x84_64"]
#     }
# }
