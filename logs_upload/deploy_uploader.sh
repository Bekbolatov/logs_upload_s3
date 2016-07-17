#!/bin/bash

echo "MAKE SURE on_signal_file = '/EFS/conf/log_uploader_on' is turned off for maint mode"

set -e

# build Docker image
docker build -t renatbek/logs:test .
docker tag renatbek/logs:test 445803720301.dkr.ecr.us-west-2.amazonaws.com/renatbek/logs:test

# push to registry
eval "$(aws ecr get-login --region us-west-2)"
docker push 445803720301.dkr.ecr.us-west-2.amazonaws.com/renatbek/logs:test


# register new task definition/revision
aws ecs register-task-definition --cli-input-json file:///Users/rbekbolatov/repos/gh/bekbolatov/LogsS3Upload/task_def.json

# get latest revision number
export REVISION="$(aws ecs list-task-definitions --family-prefix LogUploader --sort DESC --max-items 1 | jq -r '.taskDefinitionArns[0]' | awk -F : '{ print $7 }')"

# set new task definition for the service
#aws ecs update-service --cluster mini --service LogUploader --task-definition LogUploader:$REVISION
