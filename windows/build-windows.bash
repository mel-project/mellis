#!/bin/bash
set -e

cd `dirname "$(readlink -f "$0")"`


ISCC="./iscc/ISCC.exe"
rm -rfv iscc
mkdir -p iscc
unzip IS6.zip -d iscc
cargo install --locked --path ../ginkou-loader
cargo install --locked --path ../melwalletd
# (cd ../ginkou && npm ci && npm run build)

mkdir -p dir
cp $(which melwalletd) dir
cp $(which ginkou-loader) dir
sh -c "$ISCC setup.iss"
