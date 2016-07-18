#!/bin/bash

set -e

echo "Redeploying service $SERVICENAME with new definition $TASK_FAMILY:$REVISION"
aws ecs update-service --cli-input-json file://./$AWS_CONF_TARGET_DIR/update_service_config.json > logs/update-service.log
