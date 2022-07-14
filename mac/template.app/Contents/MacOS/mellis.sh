#!/bin/bash
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 2>&1 | tee /tmp/mellis.log # output to a log file and to stdout

ROOT_DIRECTORY=$( cd "$(dirname "$0")" ; pwd -P )
RESOURCE_DIRECTORY="${ROOT_DIRECTORY}/res"

export PATH=${RESOURCE_DIRECTORY}:${PATH}
export DEBUG=${DEBUG:-0} # DEBUG with default value of 0

if [ "${DEBUG}" -gt 0 ]; then
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

ginkou-loader --html-path "${RESOURCE_DIRECTORY}/ginkou-public" #wrapped in quotes to prevent issues when RESOURCE_DIRECTORY contains a space


 [ "$DEBUG" -gt 0 ] && read -p "Press Return to Close..."