//bastion
resource "aws_security_group" "sg_bastion_g2" {
    name = "${var.name_project}sg_bastion"
    description = "sg for bastion"
    vpc_id = aws_vpc.vpc_g2.id

    tags = {
        Name = "${var.name_project}sg_bastion"
    }
    ingress {
        description      = "ssh"
        from_port        = 22 //SSH
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"] #VERIFICAR
        
    }
    
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        
    }

}
//jenkins
resource "aws_security_group" "sg_jenkins_g2" {
  name = "${var.name_project}sg_jenkins"
  description = "sg for jenkins"
  vpc_id = aws_vpc.vpc_g2.id

    tags = {
        Name = "${var.name_project}sg_jenkins"
    }   
    ingress {
        description      = "bastion"
        from_port        = 22 //SSH
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["${chomp(aws_instance.bastion_g2.private_ip)}/32"]
        
    }
    ingress {
        description      = "http"
        from_port        = 80 //SSH
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"] #VERIFICAR
        
    }
    ingress {
        description      = "https"
        from_port        = 443 //SSH
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"] #VERIFICAR
        
    }
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        
    }
    depends_on = [
      aws_instance.bastion_g2
    ]

}