#!/bin/bash
set -e

while getopts "p:n:e:i:d" OPT
do
  case $OPT in
    p) WEB_PROJECT=$OPTARG;;
    n) WEB_NAME=$OPTARG;;
    e) WEB_ENVIRONMENT=$OPTARG;;
    i) WEB_INCLUDES=$OPTARG;;
    d) WEB_DAEMON=1;;
    *) echo "Unknown argument";;
  esac
done

echo $WEB_INCLUDES

if [[ -z $WEB_PROJECT ]]; then
  echo "Project path is required"
  exit 1
fi

if [[ -z $WEB_ENVIRONMENT ]]; then
  WEB_ENVIRONMENT=development
fi

if [[ -z $WEB_NAME ]]; then
  WEB_NAME=rails-$WEB_ENVIRONMENT
fi

if [[ ! -d "./environments/$WEB_ENVIRONMENT" ]]; then

  echo "Environment '$WEB_ENVIRONMENT' does not exist"
  exit 2

else

  if [[ ! -e "./environments/$WEB_ENVIRONMENT/docker-compose.yml" ]]; then
    echo "Environment '$WEB_ENVIRONMENT' does not contain a 'docker-compose.yml' file"
    exit 3
  fi
fi

# if mount | grep

echo "sudo mount -o bind $WEB_PROJECT ./web/main/"
# echo "sudo umount $WEB_PROJECT"

echo "docker-compose -p $WEB_NAME -f ./environments/$WEB_ENVIRONMENT/docker-compose.yml up -d"
# docker-compose -p $WEB_NAME -f ./environments/$WEB_ENVIRONMENT/docker-compose.yml up

# shift $($# -1)

echo $1

# echo "Others $(@)"
