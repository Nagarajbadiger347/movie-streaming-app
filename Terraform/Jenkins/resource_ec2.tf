resource "aws_instance" "jenkins" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    key_name = aws_key_pair.ssh_key.id
    vpc_security_group_ids = [aws_security_group.sg.id]
    subnet_id = aws_subnet.public.id
    associate_public_ip_address = true
    user_data = file("jenkins.sh")
    tags = {
        Name = "jenkins"
    }
    volume_tags = {
      name = "jenkins"

    }
  
}
data "aws_ami" "ubuntu" {
    most_recent = true
  owners = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ssh_key" {
    key_name   = "jenkins"
  public_key = data.local_file.public_key.content  
}

data "local_file" "public_key" {
  filename = "${path.module}/jenkins_rsa.pub"
}




