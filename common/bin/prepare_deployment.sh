#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Preparing deployment configs in $PWD"

set -o allexport
source $DIR/../etc/COMMON_SETTINGS
set +o allexport

mkdir -p logs

export AWS_CONF_TARGET_DIR=target/aws_configs

mkdir -p $AWS_CONF_TARGET_DIR
rm -rf $AWS_CONF_TARGET_DIR/*
cp -rf $DIR/../etc/aws/templates/* $AWS_CONF_TARGET_DIR/.

sed -i '.bak' -e "s/DOCKER_USER/$DOCKER_USER/g" $AWS_CONF_TARGET_DIR/*.json
sed -i '.bak' -e "s/DOCKER_IMAGE/$DOCKER_IMAGE/g" $AWS_CONF_TARGET_DIR/*.json
sed -i '.bak' -e "s/DOCKER_REGISTRY/$DOCKER_REGISTRY/g" $AWS_CONF_TARGET_DIR/*.json
sed -i '.bak' -e "s/CLUSTERNAME/$CLUSTERNAME/g" $AWS_CONF_TARGET_DIR/*.json
sed -i '.bak' -e "s/TASK_FAMILY/$TASK_FAMILY/g" $AWS_CONF_TARGET_DIR/*.json
sed -i '.bak' -e "s/TASK_COUNT/$TASK_COUNT/g" $AWS_CONF_TARGET_DIR/*.json
sed -i '.bak' -e "s/SERVICE_TASK_COUNT_MAX/$SERVICE_TASK_COUNT_MAX/g" $AWS_CONF_TARGET_DIR/*.json
sed -i '.bak' -e "s/SERVICE_TASK_COUNT_MIN/$SERVICE_TASK_COUNT_MIN/g" $AWS_CONF_TARGET_DIR/*.json
sed -i '.bak' -e "s/SERVICENAME/$SERVICENAME/g" $AWS_CONF_TARGET_DIR/*.json
sed -i '.bak' -e "s/SET_MEMORY/$SET_MEMORY/g" $AWS_CONF_TARGET_DIR/*.json
sed -i '.bak' -e "s/SET_CPU/$SET_CPU/g" $AWS_CONF_TARGET_DIR/*.json
sed -i '.bak' -e "s/PORT_MAPPING/$PORT_MAPPING/g" $AWS_CONF_TARGET_DIR/*.json
sed -i '.bak' -e "s/AWSLOGS_GROUP/$AWSLOGS_GROUP/g" $AWS_CONF_TARGET_DIR/*.json

