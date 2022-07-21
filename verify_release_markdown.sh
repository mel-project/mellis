#!/bin/bash

CHANGELOG_VERSION=$(head -1 CHANGELOG.md | tr -d ['#'] | tr -d [:blank:])

LATEST_VERSION=$(head -1 LATEST_VERSION.md | tr -d ['#'] | tr -d [:blank:])


if [ "$CHANGELOG_VERSION" == "$LATEST_VERSION" ]; then
  echo "Top entry for version in CHANGELOG.md and LATEST_VERSION.md match. Continuing."

else
  echo "Top entry for version in CHANGELOG.md and LATEST_VERSION.md do not match."
  echo "Make sure that these files are up to date."
  exit 1
fi