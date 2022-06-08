#!/bin/bash

ROOT_DIRECTORY="$(pwd $(dirname "$0"))"
RESOURCE_DIRECTORY="${ROOT_DIRECTORY}/res"
export PATH=${RESOURCE_DIRECTORY}:${PATH}

if [ -n "${DEBUG}" ]; then
  set -x

  ls -la "${ROOT_DIRECTORY}"
  ls -la "${RESOURCE_DIRECTORY}"

  which melwalletd
  which ginkou-loader
fi

ginkou-loader --html-path ${RESOURCE_DIRECTORY}/ginkou-public