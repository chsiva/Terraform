#!/bin/sh
whoami
echo "This is my IP"
curl -s ifconfig.co
echo "This is my hostname"
hostname -f
echo "list gcs in my project"
gsutil ls
