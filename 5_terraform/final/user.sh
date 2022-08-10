#! /bin/bash
sudo yum install httpd -y
EC2_AVAIL_ZONE=`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone`
echo "<h1> Instance Launched Successfully!! <br/> SINCE $EC2_AVAIL_ZONE</h1>"  > /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
amazon-linux-extras install epel -y
yum -y install certbot python2-certbot-apache mod_ssl openssl
certbot --apache -d  $(cat "/proc/sys/kernel/hostname").com  --agree-tos --register-unsafely-without-email