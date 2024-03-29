#!/bin/bash

set -e

echo "Run task with new definition $TASK_FAMILY:$REVISION"
aws ecs run-task --cli-input-json file://./$AWS_CONF_TARGET_DIR/run_task_config.json > logs/run-task.log
