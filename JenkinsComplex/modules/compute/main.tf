#------compute/main.tf----------

provider "aws" {
  region = var.region
}

data "aws_ssm_parameter" "webserver-ami"{
    name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Create key-pair for logging into EC2
resource "aws_key_pair" "aws-key" {
  key_name   = "jenkins"
  public_key = file(var.ssh_key_public)
}


#create and bootstrap the jenkins master server
resource "aws_instance" "jenkins-master" {
  instance_type = "t2.medium"
  ami           = data.aws_ssm_parameter.webserver-ami.value
  tags = {
    Name = "jenkins_master"
  }
  key_name                    = aws_key_pair.aws-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_group]
  subnet_id                   = var.subnets

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.ssh_key_private)
    host        = self.public_ip
  }

  #copy from the local machine to EC2
  provisioner "file" {
    source      = "${path.root}/install_jenkins_master.yaml"
    destination = "install_jenkins_master.yaml"
  }

  #execute a script where we install ansible and
  #run the above file
  provisioner "remote-exec" {
    inline = [ 
      "sudo yum update -y && sudo yum install ansible -y && sudo yum install java-17-amazon-corretto-headless -y",
      "sleep 60s",
      "ansible-playbook install_jenkins_master.yaml" ]
  }

}

#creating our jenkins python node
resource "aws_instance" "jenkins-python-node" {
  instance_type = "t2.micro"
  ami           = data.aws_ssm_parameter.webserver-ami.value
  tags = {
    Name = "jenkins_python_node"
  }

  key_name                    = aws_key_pair.aws-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [ var.security_group ]
  subnet_id                   = var.subnets

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.ssh_key_private)
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "${path.root}/install_jenkins_python_node.yaml"
    destination = "install_jenkins_python_node.yaml"
  }

  provisioner "remote-exec" {
    inline = [ 
        "sudo yum update -y && sudo yum install ansible -y && sudo yum install java-17-amazon-corretto-headless -y",
        "sleep 60s",
        "ansible-playbook install_jenkins_python_node.yaml"
     ]
  }

}