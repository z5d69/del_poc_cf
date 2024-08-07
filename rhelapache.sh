#!/bin/bash
sudo yum install httpd -y
sudo systemctl start httpd  
sudo firewall-cmd --add-service=http
