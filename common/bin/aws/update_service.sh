#!/bin/bash

set -e

echo "Redeploying service $SERVICENAME with new definition $TASK_FAMILY:$REVISION"
aws ecs update-service --cli-input-json file://./deployment/target/update_service_config.json > logs/update-service.log
