#!/bin/bash

set -e

echo "Registering a new task definition"
aws ecs register-task-definition --cli-input-json file://./deployment/target/task_definition_config.json > logs/register-task-definition.log

export REVISION="$(aws ecs list-task-definitions --family-prefix $TASK_FAMILY --sort DESC --max-items 1 | jq -r '.taskDefinitionArns[0]' | awk -F : '{ print $7 }')"

echo "... new revision is: $REVISION"
