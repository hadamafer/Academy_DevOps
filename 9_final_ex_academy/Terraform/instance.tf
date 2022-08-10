//bastion
resource "aws_instance" "bastion_g2" { 
    ami= data.aws_ami.amazon-linux-2.id
    subnet_id = aws_subnet.sb_pub_g2.id
    vpc_security_group_ids = [aws_security_group.sg_bastion_g2.id]
    instance_type = "t2.micro"
    key_name = var.key_name
    associate_public_ip_address= true 
    //user_data = file("user.sh")

    tags = {
        Name = "${var.name_project}bastion"
    }

    root_block_device {
        volume_size = "30"
        encrypted = false
    }

    provisioner "file" {
        source = "key.pem"
        destination = "key.pem"
      
    }
    provisioner "remote-exec" {
        inline = [
          "chmod 400 key.pem"
        ]
      on_failure = continue
    }
    connection {
      type = "ssh"
      user = "ec2-user"
      host = self.public_ip
      private_key =  file(local.key_path)
    }
    # provisioner "local-exec" {
    #     command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${aws_instance.bastion_g2.public_ip}, --user ec2-user --private-key ${local.key_path}  nginx.yml"
      
    # }
}
//jenkins
resource "aws_instance" "jenkins_g2" { 
    ami= data.aws_ami.amazon-linux-2.id
    subnet_id = aws_subnet.sb_pub_g2.id
    vpc_security_group_ids = [aws_security_group.sg_jenkins_g2.id]
    instance_type = "t2.micro"
    key_name = var.key_name
    //associate_public_ip_address=  true //no estoy segura de esto pero creo q si
    //user_data = file("jenkins.sh") #VER 

    tags = {
        Name = "${var.name_project}jenkins"
    }

    # root_block_device {
    #     volume_size = "30"
    #     encrypted = false
    # }
    # connection {
    #   type = "ssh"
    #   user = "ec2-user"
    #   host = self.public_ip
    #   private_key =  file(local.key_path)
    # }
    # provisioner "local-exec" {
    #     command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${aws_instance.jenkins_g2.public_ip}, --user ec2-user --private-key ${local.key_path} jenkins.yml"
      
    # }
}