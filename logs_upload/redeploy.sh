#!/bin/bash

set -e

set -o allexport
source SETTINGS
set +o allexport

############################################################
############################################################

source ../common/bin/task_definition/publish_new_revision.sh

source ../common/bin/aws/update_service.sh
