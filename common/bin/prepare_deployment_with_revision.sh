#!/bin/bash

set -e

export REVISION="$(aws ecs list-task-definitions --family-prefix $TASK_FAMILY --sort DESC --max-items 1 | jq -r '.taskDefinitionArns[0]' | awk -F : '{ print $7 }')"
echo "... using revision: $REVISION"

sed -i '.bak' -e "s/REVISION/$REVISION/g" $AWS_CONF_TARGET_DIR/*.json
rm -rf $AWS_CONF_TARGET_DIR/*.bak
