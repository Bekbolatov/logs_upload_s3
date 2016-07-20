#!/bin/bash

set -e

set -o allexport
source SETTINGS
set +o allexport

############################################################
echo "Collecting new configs"
TARGET_CONF_DIR=target/conf
mkdir -p $TARGET_CONF_DIR
cp -rf ../polling_tasks/conf/* $TARGET_CONF_DIR/.
############################################################

source $DISTRIB_HOME/bin/task_definition/publish_new_revision.sh

source $DISTRIB_HOME/bin/aws/run_task.sh

