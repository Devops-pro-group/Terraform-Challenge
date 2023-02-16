
#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo yum enable httpd
sudo systemctl start httpd
sudo  systemctl status htpd
echo " Hello World " >> /var/www/html/index.html