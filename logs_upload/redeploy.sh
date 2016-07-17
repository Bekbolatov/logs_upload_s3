#!/bin/bash

TASK_FAMILY=LogUploader
SERVICENAME=$TASK_FAMILY
CLUSTERNAME=mini
SET_MEMORY=300
SET_CPU=300
AWSLOGS_GROUP=sparkydots_log_uploader

DOCKER_REGISTRY=445803720301.dkr.ecr.us-west-2.amazonaws.com
DOCKER_USER=renatbek
DOCKER_IMAGE=logs:test

set -e

#SKIP_DOCKER_PUSH=true
#SKIP_TASK_REGISTRATION=true

source ../common/bin/task_definition/publish_new_revision.sh

source ../common/bin/aws/update_service.sh
