//bastion
resource "aws_instance" "bastion_fer" { 
    ami= data.aws_ami.amazon-linux-2.id
    subnet_id = aws_subnet.sb_pub1_fer.id
    vpc_security_group_ids = [aws_security_group.sg_bastion_fer.id]
    instance_type = "t2.micro"
    key_name = var.key_name
    associate_public_ip_address= true //no estoy segura de esto pero creo q si
    user_data = file("user.sh")

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
      private_key = file("key.pem")
    }
}

//proxy [tiene ip elastica ]
resource "aws_instance" "proxy_fer" { 
    ami= data.aws_ami.amazon-linux-2.id
    subnet_id = aws_subnet.sb_pub2_fer.id
    vpc_security_group_ids = [aws_security_group.sg_proxy_fer.id]
    instance_type = "t2.micro"
    key_name = var.key_name
    //associate_public_ip_address=  true //no estoy segura de esto pero creo q si
    user_data = file("user_proxy.sh")

    tags = {
        Name = "${var.name_project}proxy"
    }

    root_block_device {
        volume_size = "30"
        encrypted = false
    }
}
//app1
resource "aws_instance" "app1_fer" { 
    ami= data.aws_ami.amazon-linux-2.id
    subnet_id = aws_subnet.sb_priv1_fer.id
    vpc_security_group_ids = [aws_security_group.sg_app_fer.id]
    instance_type = "t2.micro"
    key_name = var.key_name
    //associate_public_ip_address= true //no estoy segura de esto pero creo q si
    user_data = file("user_app1.sh")

    
    tags = {
        Name = "${var.name_project}app1"
    }

    root_block_device {
        volume_size = "30"
        encrypted = false
    }
}

//app2
resource "aws_instance" "app2_fer" { 
    ami= data.aws_ami.amazon-linux-2.id
    subnet_id = aws_subnet.sb_priv2_fer.id
    vpc_security_group_ids = [aws_security_group.sg_app_fer.id]
    instance_type = "t2.micro"
    key_name = var.key_name
    //associate_public_ip_address= true //no estoy segura de esto pero creo q si
    user_data = file("user_app2.sh")

    
    tags = {
        Name = "${var.name_project}app2"
    }

    root_block_device {
        volume_size = "30"
        encrypted = false
    }
}