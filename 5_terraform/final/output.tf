output "dns_lb" {

  value = aws_lb.lb_fer.dns_name

}

output "ip_private_proxy" {
    value = aws_instance.proxy_fer.private_ip
  
}

output "ip_public_bastion" {
  value = aws_instance.bastion_fer.public_ip
}