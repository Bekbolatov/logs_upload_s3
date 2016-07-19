#!/bin/bash

set -e

SG_GROUP_ECS="sg-eb3e498d"
SG_GROUP_RDS="sg-03b8cd65"


CIDR=$(aws ec2 describe-security-groups --group-id $SG_GROUP_ECS  | jq -r '.SecurityGroups[0].IpPermissions | map(select(.FromPort == 22)) | .[0].IpRanges[0].CidrIp')
echo "Previous CIDR for ECS: $CIDR"
if [[ "$CIDR" != "null" ]]; then
    aws ec2 revoke-security-group-ingress --group-id $SG_GROUP_ECS --protocol tcp --port 22 --cidr $CIDR
fi

CIDR=$(aws ec2 describe-security-groups --group-id $SG_GROUP_RDS  | jq -r '.SecurityGroups[0].IpPermissions | map(select(.FromPort == 22)) | .[0].IpRanges[0].CidrIp')
echo "Previous CIDR for RDS: $CIDR"
if [[ "$CIDR" != "null" ]]; then
    aws ec2 revoke-security-group-ingress --group-id $SG_GROUP_RDS --protocol tcp --port 3306 --cidr $CIDR
fi


CIDR=$(curl ifconfig.co)"/32"
echo "New CIDR: $CIDR"
if [[ "$CIDR" != "null" ]]; then
    sleep 5
    aws ec2 authorize-security-group-ingress --group-id $SG_GROUP_ECS --protocol tcp --port 22 --cidr $CIDR
    aws ec2 authorize-security-group-ingress --group-id $SG_GROUP_RDS --protocol tcp --port 3306 --cidr $CIDR
fi

#aws ec2 authorize-security-group-ingress --group-id sg-eb3e498d --protocol tcp --port 8081 --cidr $CIDR
