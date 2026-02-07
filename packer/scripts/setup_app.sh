#!/bin/bash
set -e

APP_DIR="/opt/book-app"

sudo mkdir -p $APP_DIR
sudo rm -rf $APP_DIR/*

# move uploaded folder
sudo mv /tmp/book-app/* $APP_DIR/

sudo chown -R ec2-user:ec2-user $APP_DIR

cd $APP_DIR

python3 -m pip install --upgrade pip

# install dependencies
if [ -f requirements.txt ]; then
  python3 -m pip install -r requirements.txt
fi

# install gunicorn
python3 -m pip install gunicorn

