#!/bin/bash

ROOT_DIRECTORY="$(pwd $(dirname "$0"))"
RESOURCE_DIRECTORY="${ROOT_DIRECTORY}/res"
PATH=${RESOURCE_DIRECTORY}:${PATH}

if [ -n "${DEBUG}" ]; then
  which melwalletd
  which ginkou-loader
fi

ginkou-loader --html-path ${RESOURCE_DIRECTORY}/ginkou-public