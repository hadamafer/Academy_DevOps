// VPC
resource "aws_vpc" "vpc_g2" {
    cidr_block       = var.cidrvpc
    instance_tenancy = "default"

    tags = {
        Name = "${var.name_project}vpc"
    }
  
}
//------subnet PUBLIC
resource "aws_subnet" "sb_pub_g2" {
    vpc_id            = aws_vpc.vpc_g2.id
    cidr_block        = var.cidr_sb_pub
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.name_project}sub_pub"
    }
}

//----- INTERNET GATEWAY ----
resource "aws_internet_gateway" "ig_g2" {
    vpc_id = aws_vpc.vpc_g2.id
    
    tags = {
        Name = "${var.name_project}ig"
    }
   
}
//route table PUBLIC
resource "aws_route_table" "rt_pub_g2"{
    vpc_id = aws_vpc.vpc_g2.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ig_g2.id
    }
    tags = {
        Name = "${var.name_project}rt_pub"
    }
}
//asociacion
resource "aws_route_table_association" "as1_rtpub_g2" {
    subnet_id      = aws_subnet.sb_pub_g2.id
    route_table_id = aws_route_table.rt_pub_g2.id
}
