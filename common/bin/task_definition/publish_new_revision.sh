#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/../prepare_deployment.sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [[ $SKIP_DOCKER_PUSH != "true" ]]; then
    source $DIR/../docker/build_push.sh
else
    echo "WARNING: Skipping Docker build/push"
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [[ $SKIP_TASK_REGISTRATION != "true" ]]; then
    source $DIR/../aws/register_task_definition.sh
else
    echo "WARNING: Skipping task registration"
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/../prepare_deployment_with_revision.sh
