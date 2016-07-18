#!/bin/bash

set -e

set -o allexport
source SETTINGS
set +o allexport

############################################################
echo "Collecting new configs"
TARGET_CONF_DIR=target/conf
mkdir -p $TARGET_CONF_DIR
cp -rf ../logs_upload/conf/* $TARGET_CONF_DIR/.
cp -rf ../sparkydots/conf/* $TARGET_CONF_DIR/.
############################################################

source ../common/bin/task_definition/publish_new_revision.sh

source ../common/bin/aws/run_task.sh

