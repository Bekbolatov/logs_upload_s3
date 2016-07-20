#!/bin/bash

set -e

set -o allexport
source SETTINGS
set +o allexport

############################################################
############################################################

source $DISTRIB_HOME/bin/task_definition/publish_new_revision.sh

#source $DISTRIB_HOME/bin/aws/update_service.sh
source $DISTRIB_HOME/bin/aws/run_task.sh
