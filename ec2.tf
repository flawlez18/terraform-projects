module "ec2_instance" {
    source = "./ec2module"
    instance_type = var.instance_type
    ami = data.aws_ami.amzlinux2.id
    
   
}

