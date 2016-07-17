#!/bin/bash

set -e

echo "Preparing deployment configs in $PWD"

mkdir -p logs
mkdir -p deployment/target
rm -rf deployment/target/*.json
cp deployment/*.json deployment/target/.
sed -i '.bak' -e "s/DOCKER_USER/$DOCKER_USER/g" deployment/target/*.json
sed -i '.bak' -e "s/DOCKER_IMAGE/$DOCKER_IMAGE/g" deployment/target/*.json
sed -i '.bak' -e "s/DOCKER_REGISTRY/$DOCKER_REGISTRY/g" deployment/target/*.json
sed -i '.bak' -e "s/CLUSTERNAME/$CLUSTERNAME/g" deployment/target/*.json
sed -i '.bak' -e "s/TASK_FAMILY/$TASK_FAMILY/g" deployment/target/*.json
sed -i '.bak' -e "s/SERVICENAME/$SERVICENAME/g" deployment/target/*.json
sed -i '.bak' -e "s/SET_MEMORY/$SET_MEMORY/g" deployment/target/*.json
sed -i '.bak' -e "s/SET_CPU/$SET_CPU/g" deployment/target/*.json
sed -i '.bak' -e "s/AWSLOGS_GROUP/$AWSLOGS_GROUP/g" deployment/target/*.json
