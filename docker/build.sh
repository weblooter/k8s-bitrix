#!/bin/bash

read -p "Type COMPOSE_PROJECT_NAME from .env: " COMPOSE_PROJECT_NAME

read -p "Type version (example v1.2) or leave it empty to be the \"latest\": " IMAGE_VERSION
IMAGE_VERSION=${IMAGE_VERSION:-latest}

read -p "\"${COMPOSE_PROJECT_NAME}:${IMAGE_VERSION}\" will be built. Continue (y/N)? " choice
echo $'\n'

if [[ $choice =~ ^[Yy]$ ]]; then
    docker-compose build --no-cache --parallel

    echo $'\n'
    echo "Images:"
    docker tag ${COMPOSE_PROJECT_NAME}_nginx:latest localhost:32000/${COMPOSE_PROJECT_NAME}_nginx:$IMAGE_VERSION
    docker tag ${COMPOSE_PROJECT_NAME}_workspace:latest localhost:32000/${COMPOSE_PROJECT_NAME}_workspace:$IMAGE_VERSION
    docker tag ${COMPOSE_PROJECT_NAME}_mysql:latest localhost:32000/${COMPOSE_PROJECT_NAME}_mysql:$IMAGE_VERSION

    docker images | grep "localhost:32000/${COMPOSE_PROJECT_NAME}"

    echo $'\n'
    read -p "Do you wanna push (y/N)?" choice
    if [[ $choice =~ ^[Yy]$ ]]; then
        docker push localhost:32000/${COMPOSE_PROJECT_NAME}_nginx:$IMAGE_VERSION
        docker push localhost:32000/${COMPOSE_PROJECT_NAME}_workspace:$IMAGE_VERSION
        docker push localhost:32000/${COMPOSE_PROJECT_NAME}_mysql:$IMAGE_VERSION
        
        echo $'\n'
        echo "Pushed."
    else
        echo "Build is finished." && exit 1 || return 1
    fi
else
    echo "Build aborted." && exit 1 || return 1
fi