// VPC
resource "aws_vpc" "vpc_fer" {
    cidr_block       = var.cidrvpc
    instance_tenancy = "default"

    tags = {
        Name = "${var.name_project}vpc"
    }
  
}

//------subnet PUBLIC
// sb1
resource "aws_subnet" "sb_pub1_fer" {
    vpc_id            = aws_vpc.vpc_fer.id
    cidr_block        = var.cidr_sb_pub1
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.name_project}sub_pub1"
    }
}

//sb2
resource "aws_subnet" "sb_pub2_fer" {
    vpc_id            = aws_vpc.vpc_fer.id
    cidr_block        = var.cidr_sb_pub2
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.name_project}sub_pub2"
    }
}

//-------subnet PRIVATE 

//sb1
resource "aws_subnet" "sb_priv1_fer" {
    vpc_id            = aws_vpc.vpc_fer.id
    cidr_block        = var.cidr_sb_priv1
    availability_zone = "us-east-1a"

    tags = {
        Name = "${var.name_project}sub_priv1"
    }
}

//sb2
resource "aws_subnet" "sb_priv2_fer" {
    vpc_id            = aws_vpc.vpc_fer.id
    cidr_block        = var.cidr_sb_priv2
    availability_zone = "us-east-1b"

    tags = {
        Name = "${var.name_project}sub_priv2"
    }
}

//----- INTERNET GATEWAY ----
resource "aws_internet_gateway" "ig_fer" {
    vpc_id = aws_vpc.vpc_fer.id
    
    tags = {
        Name = "${var.name_project}ig"
    }
   
}

//route table PUBLIC
resource "aws_route_table" "rt_pub_fer"{
    vpc_id = aws_vpc.vpc_fer.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ig_fer.id
    }
    tags = {
        Name = "${var.name_project}rt_pub"
    }
}

/* //verifcar
resource "aws_route_table" "rt_pub2_fer"{
    vpc_id = aws_vpc.vpc_fer.id
    route {
        cidr_block = "0.0.0.0/0"
        load_balancer_arn = aws_lb.lb_fer.arn
    }
    tags = {
        Name = "${var.name_project}rt_pub"
    }
}
 */
//asociacion
resource "aws_route_table_association" "as1_rtpub_fer" {
    subnet_id      = aws_subnet.sb_pub1_fer.id
    route_table_id = aws_route_table.rt_pub_fer.id
}
resource "aws_route_table_association" "as2_rtpub_fer" {
    subnet_id      = aws_subnet.sb_pub2_fer.id
    route_table_id = aws_route_table.rt_pub_fer.id
}

/* //verificar 
resource "aws_route_table_association" "as3_rtpub_fer" {
    subnet_id      = aws_subnet.sb_pub2_fer.id
    route_table_id = aws_route_table.rt_pub2_fer.id
}
 */

//---- NAT---
//ip elastica
resource "aws_eip" "eip_fer" {
    vpc = true
    tags = {
        Name = "${var.name_project}eip_nat"
    }
}

//nat
resource "aws_nat_gateway" "nat_fer" {
    allocation_id = aws_eip.eip_fer.id
    subnet_id = aws_subnet.sb_pub1_fer.id
    depends_on = [
        aws_internet_gateway.ig_fer
    ]
    tags = {
        Name = "${var.name_project}nat"
    }

}

//route table PIRVATE
resource "aws_route_table" "rt_priv_fer" {
    vpc_id = aws_vpc.vpc_fer.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat_fer.id
    }
    tags = {
        Name = "${var.name_project}rt_priv"
    }

}



//asociacion
resource "aws_route_table_association" "as1_rtpriv_fer" {
    subnet_id      = aws_subnet.sb_priv1_fer.id
    route_table_id = aws_route_table.rt_priv_fer.id
}
resource "aws_route_table_association" "as2_rtpriv_fer" {
    subnet_id      = aws_subnet.sb_priv2_fer.id
    route_table_id = aws_route_table.rt_priv_fer.id
}


//ip elastica para proxy 
resource "aws_eip" "eip_proxy_fer" {
    vpc = true
    tags = {
        Name = "${var.name_project}eip_prozy"
    }
    instance = aws_instance.proxy_fer.id
    depends_on = [
      aws_instance.proxy_fer
    ]
}