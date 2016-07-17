#!/bin/bash

set -e

echo "Building a new image: $DOCKER_USER/$DOCKER_IMAGE in $PWD"
echo "... building ..."
docker build -t $DOCKER_USER/$DOCKER_IMAGE . > logs/docker-build.log
docker tag $DOCKER_USER/$DOCKER_IMAGE $DOCKER_REGISTRY/$DOCKER_USER/$DOCKER_IMAGE

eval "$(aws ecr get-login --region us-west-2)"
echo "... pushing ..."
docker push $DOCKER_REGISTRY/$DOCKER_USER/$DOCKER_IMAGE
