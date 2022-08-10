//bastion
resource "aws_security_group" "sg_bastion_fer" {
    name = "${var.name_project}sg_bastion"
    description = "sg for bastion"
    vpc_id = aws_vpc.vpc_fer.id

    tags = {
        Name = "${var.name_project}sg_bastion"
    }   
    ingress {
        description      = "https"
        from_port        = 443 //https
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        
    }
    ingress {
        description      = "http"
        from_port        = 80 //HTTP
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        
    }
    ingress {
        description      = "ssh"
        from_port        = 22 //SSH
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["181.30.225.240/32"]
        
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        
    }

}

//proxy
resource "aws_security_group" "sg_proxy_fer" {
  name = "${var.name_project}sg_proxy"
  description = "sg for bastion"
  vpc_id = aws_vpc.vpc_fer.id

    tags = {
        Name = "${var.name_project}sg_proxy"
    }   
/*     ingress {
        description      = "https"
        from_port        = 443 //https
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        
    }
    ingress {
        description      = "http"
        from_port        = 80 //HTTP
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        
    }  */
    ingress {
        description      = "bastion"
        from_port        = 22 //SSH
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["${chomp(aws_instance.bastion_fer.private_ip)}/32"]
        
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        
    }
    depends_on = [
      aws_instance.bastion_fer
    ]

}

//load balancer 
resource "aws_security_group" "sg_lb_fer" {
    name = "${var.name_project}sg_lb"
    description = "sg for bastion"
    vpc_id = aws_vpc.vpc_fer.id

    tags = {
        Name = "${var.name_project}sg_lb"
    }  
    // 
    ingress {
        description      = "https"
        from_port        = 443 //https
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["${chomp(aws_instance.proxy_fer.private_ip)}/32"]
        
    }
    ingress {
        description      = "http"
        from_port        = 80 //HTTP
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["${chomp(aws_instance.proxy_fer.private_ip)}/32"]
        
    } 
    // verificar 
    ingress {
        description      = "proxy"
        from_port        = 22 //SSH
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["${chomp(aws_instance.proxy_fer.private_ip)}/32"]
        
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        
    }

}

// apps
resource "aws_security_group" "sg_app_fer" {
    name = "${var.name_project}sg_app"
    description = "sg for bastion"
    vpc_id = aws_vpc.vpc_fer.id

    tags = {
        Name = "${var.name_project}sg_app"
    }   
    ingress {
        description      = "lb"
        from_port        = 80 //HTTP
        to_port          = 80
        protocol         = "tcp"
        security_groups = [aws_security_group.sg_lb_fer.id] //verificar 
    }
    ingress {
        description      = "lb"
        from_port        = 22 //HTTP
        to_port          = 22
        protocol         = "tcp"
        security_groups = [aws_security_group.sg_lb_fer.id] //verificar 
    }
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        
    }
    depends_on = [
        aws_security_group.sg_lb_fer
    ]

}