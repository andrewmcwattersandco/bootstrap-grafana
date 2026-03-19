#!/bin/sh

# https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/
sudo apt-get update
sudo apt-get install -y apt-transport-https wget gnupg

sudo mkdir -p /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/grafana.asc https://apt.grafana.com/gpg-full.key
sudo chmod 644 /etc/apt/keyrings/grafana.asc

echo "deb [signed-by=/etc/apt/keyrings/grafana.asc] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Updates the list of available packages
sudo apt-get update

# Installs the latest OSS release:
sudo apt-get install grafana

# https://grafana.com/docs/grafana/latest/setup-grafana/start-restart-grafana/
sudo systemctl daemon-reload
sudo systemctl start grafana-server

sudo systemctl status grafana-server

sudo systemctl enable grafana-server.service

# https://grafana.com/docs/grafana/latest/setup-grafana/set-up-https/#obtain-a-signed-certificate-from-letsencrypt
sudo apt-get install snapd
sudo snap install core; sudo snap refresh core

sudo apt-get remove certbot
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

sudo certbot certonly --standalone

# sudo ln -s /etc/letsencrypt/live/subdomain.mysite.com/privkey.pem /etc/grafana/grafana.key
# sudo ln -s /etc/letsencrypt/live/subdomain.mysite.com/fullchain.pem /etc/grafana/grafana.crt

# sudo chgrp -R grafana /etc/letsencrypt/*
# sudo chmod -R g+rx /etc/letsencrypt/*
# sudo chgrp -R grafana /etc/grafana/grafana.crt /etc/grafana/grafana.key
# sudo chmod 440 /etc/grafana/grafana.crt /etc/grafana/grafana.key

# ls -l /etc/grafana/grafana.*

sudo sed -i 's/;protocol = http/protocol = https/' /etc/grafana/grafana.ini
sudo sed -i 's|;cert_file =|cert_file = /etc/grafana/grafana.crt|' /etc/grafana/grafana.ini
sudo sed -i 's|;cert_key =|cert_key = /etc/grafana/grafana.key|' /etc/grafana/grafana.ini

sudo systemctl restart grafana-server
