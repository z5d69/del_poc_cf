#!/bin/bash
sudo firewall-offline-cmd --add-service=http
sudo systemctl restart firewalld
sudo yum install httpd -y
sudo systemctl start httpd  
