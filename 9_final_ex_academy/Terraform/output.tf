output "ip_private_bastion" {
    value = aws_instance.bastion_g2.private_ip
  
}

output "ip_public_bastion" {
  value = aws_instance.bastion_g2.public_ip
}



output "ip_private_jenkins" {
    value = aws_instance.jenkins_g2.private_ip
  
}

output "ip_public_jenkins" {
    value = aws_instance.jenkins_g2.public_ip
  
}
