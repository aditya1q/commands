#!/bin/bash

cd /root/folder_name

iptables -A INPUT -p tcp --dport 8888 -j ACCEPT

netfilter-persistent save
netfilter-persistent reload

/usr/local/bin/pm2 delete folder_name
/usr/local/bin/pm2 start main.py \
  --namespace=folder_name \
  --interpreter=/root/folder_name/venv/bin/python3 \
  --name=folder_name
