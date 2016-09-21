#!/bin/bash

set -e

SG_GROUP_ECS="sg-eb3e498d"
SG_GROUP_RDS="sg-03b8cd65"


CIDR=$(aws ec2 describe-security-groups --group-id $SG_GROUP_ECS  | jq -r '.SecurityGroups[0].IpPermissions | map(select(.FromPort == 22)) | .[0].IpRanges[0].CidrIp')
NEWCIDR=$(curl ifconfig.co)"/32"

if [[ "$CIDR" == "$NEWCIDR" ]]; then
    echo "CIDR has not changed: $CIDR"
    exit 0
fi

echo "Updating permission: $CIDR -> $NEWCIDR"

if [[ "$CIDR" != "null" ]]; then
    aws ec2 revoke-security-group-ingress --group-id $SG_GROUP_ECS --protocol tcp --port 22 --cidr $CIDR
    aws ec2 revoke-security-group-ingress --group-id $SG_GROUP_ECS --protocol tcp --port 9002 --cidr $CIDR
    aws ec2 revoke-security-group-ingress --group-id $SG_GROUP_ECS --protocol tcp --port 8080 --cidr $CIDR
    aws ec2 revoke-security-group-ingress --group-id $SG_GROUP_ECS --protocol tcp --port 8999 --cidr $CIDR
    aws ec2 revoke-security-group-ingress --group-id $SG_GROUP_ECS --protocol tcp --port 12552 --cidr $CIDR
fi

# No need to connect to RDS for now
#CIDR=$(aws ec2 describe-security-groups --group-id $SG_GROUP_RDS  | jq -r '.SecurityGroups[0].IpPermissions | map(select(.FromPort == 22)) | .[0].IpRanges[0].CidrIp')
#echo "Previous CIDR for RDS: $CIDR"
#if [[ "NEWCIDR" != "null" ]]; then
#    aws ec2 revoke-security-group-ingress --group-id $SG_GROUP_RDS --protocol tcp --port 3306 --cidr NEWCIDR
#fi


if [[ "$CIDR" != "null" ]]; then
    sleep 5
    aws ec2 authorize-security-group-ingress --group-id $SG_GROUP_ECS --protocol tcp --port 22 --cidr $NEWCIDR
    aws ec2 authorize-security-group-ingress --group-id $SG_GROUP_ECS --protocol tcp --port 9002 --cidr $NEWCIDR
    aws ec2 authorize-security-group-ingress --group-id $SG_GROUP_ECS --protocol tcp --port 8080 --cidr $NEWCIDR
    aws ec2 authorize-security-group-ingress --group-id $SG_GROUP_ECS --protocol tcp --port 8999 --cidr $NEWCIDR
    aws ec2 authorize-security-group-ingress --group-id $SG_GROUP_ECS --protocol tcp --port 12552 --cidr $NEWCIDR
    #aws ec2 authorize-security-group-ingress --group-id $SG_GROUP_RDS --protocol tcp --port 3306 --cidr NEWCIDR
fi
