// target group
resource "aws_lb_target_group" "tg_lb_fer" {
    vpc_id = aws_vpc.vpc_fer.id
    //name = "${var.name_project}tg"
    port = 80
    protocol = "HTTP"
    target_type = "instance"

    health_check {
        interval = 10
        path = "/"
        protocol = "HTTP"
        timeout = 5
        healthy_threshold = 5
        unhealthy_threshold = 2   
    }
  
}

//lb
resource "aws_lb" "lb_fer" {
    //name = "${var.name_project}lb"
    internal = true
    security_groups = [aws_security_group.sg_lb_fer.id]
    subnets = [aws_subnet.sb_priv1_fer.id, aws_subnet.sb_priv2_fer.id]
    load_balancer_type = "application"

    tags = {
        Name = "${var.name_project}lb"
    }
}

//listener 
resource "aws_lb_listener" "list_lb_fer" {
    load_balancer_arn = aws_lb.lb_fer.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.tg_lb_fer.arn
}
}

//asociacion instance to tg 
resource "aws_lb_target_group_attachment" "at1_lb_fer" {
    target_group_arn = aws_lb_target_group.tg_lb_fer.arn
    target_id = aws_instance.app1_fer.id
    port = 80 
}
resource "aws_lb_target_group_attachment" "at2_lb_fer" {
    target_group_arn = aws_lb_target_group.tg_lb_fer.arn
    target_id = aws_instance.app2_fer.id
    port = 80 
}