#!/bin/bash
set -e

sudo yum update -y

# Install Python + Git
sudo yum install -y python3 git

# Install pip
python3 -m ensurepip --upgrade
python3 -m pip install --upgrade pip

# (Optional) If you want Nginx
#sudo yum install -y nginx
#sudo systemctl enable nginx
#sudo systemctl start nginx

