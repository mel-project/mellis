#!/bin/bash
set -e

cd `dirname "$(readlink -f "$0")"`


ISCC="./iscc/ISCC.exe"
rm -rfv iscc
mkdir -p iscc
unzip IS6.zip -d iscc
# cargo install --locked --path ../ginkou-loader
# cargo install --locked --path ../melwalletd
# (cd ../ginkou && npm ci && npm run build)

mkdir -p artifacts
touch artifacts/testing.txt
# cp $(which melwalletd) artifacts
# cp $(which ginkou-loader) artifacts
sh -c "$ISCC setup.iss"
