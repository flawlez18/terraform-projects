resource "aws_instance" "demo1" {
    #ami = data.aws_ami.ubuntu.id
    # ami = data.aws_ami.amzlinux2.id
    instance_type = var.instance_type
}


resource "aws_instance" "demo2" {
    #ami = data.aws_ami.ubuntu.id
    # ami = data.aws_ami.amzlinux2.id
   instance_type = var.instance_type
}

