#!/bin/bash

set -e

SG_GROUP="sg-eb3e498d"


CIDR=$(aws ec2 describe-security-groups --group-id $SG_GROUP  | jq -r '.SecurityGroups[0].IpPermissions | map(select(.FromPort == 22)) | .[0].IpRanges[0].CidrIp')
echo "Previous CIDR: $CIDR"
if [[ "$CIDR" != "null" ]]; then
    aws ec2 revoke-security-group-ingress --group-id $SG_GROUP --protocol tcp --port 22 --cidr $CIDR
fi

CIDR=$(curl ifconfig.co)"/32"
echo "New CIDR: $CIDR"
if [[ "$CIDR" != "null" ]]; then
    sleep 5
    aws ec2 authorize-security-group-ingress --group-id $SG_GROUP --protocol tcp --port 22 --cidr $CIDR
fi

# testing
#aws ec2 authorize-security-group-ingress --group-id sg-eb3e498d --protocol tcp --port 8081 --cidr 174.31.176.170/32

