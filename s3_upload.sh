#!/bin/bash

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
SECURITY_GROUPS=$(curl -s http://169.254.169.254/latest/meta-data/security-groups)
OS_NAME=$(grep "^NAME=" /etc/os-release | awk -F'=' '{print $2}' | tr -d '"')
OS_VERSION=$(grep "^VERSION=" /etc/os-release | awk -F'=' '{print $2}' | tr -d '"')
USERS=$(awk -F: '/(bash|sh)$/ {print $1}' /etc/passwd)

FILE_NAME="instance_metadata.txt"

{
echo "Instance ID: $INSTANCE_ID"
echo "Public IP: $PUBLIC_IP"
echo "Private IP: $PRIVATE_IP"
echo "Security Groups: $SECURITY_GROUPS"
echo "Operating Systems: $OS_NAME $OS_VERSION"
echo "Users with shell access:"
echo "$USERS"
} > "$FILE_NAME"

aws s3 cp $FILE_NAME s3://applicant-task/r2d2/
