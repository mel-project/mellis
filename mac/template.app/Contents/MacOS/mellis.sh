#!/bin/bash

ROOT_DIRECTORY="$(pwd $(dirname "$0"))"
RESOURCE_DIRECTORY="${ROOT_DIRECTORY}/res"
export PATH=${RESOURCE_DIRECTORY}:${PATH}

export DEBUG=true

if [ -n "${DEBUG}" ]; then
  set -x

  echo "Root directory is ${ROOT_DIRECTORY}

  echo "Root directory contents:
  ls -la "${ROOT_DIRECTORY}"

  echo "Resource directory is ${RESOURCE_DIRECTORY}

  echo "Resource directory contents:
  ls -la "${RESOURCE_DIRECTORY}"

  which melwalletd
  which ginkou-loader
fi

ginkou-loader --html-path ${RESOURCE_DIRECTORY}/ginkou-public


read -p "Press Return to Close..."