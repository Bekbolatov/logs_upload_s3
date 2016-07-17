#!/bin/bash

TASK_FAMILY=ConfigRedeploy
SERVICENAME=$TASK_FAMILY
CLUSTERNAME=mini
SET_MEMORY=200
SET_CPU=200
AWSLOGS_GROUP=sparkydots_config

DOCKER_REGISTRY=445803720301.dkr.ecr.us-west-2.amazonaws.com
DOCKER_USER=renatbek
DOCKER_IMAGE=config:latest

set -e


echo "Collecting new configs"
cp -rf ../logs_upload/conf/* conf/.
cp -rf ../sparkydots/conf/* conf/.


source ../common/bin/task_definition/publish_new_revision.sh

source ../common/bin/aws/run_task.sh

