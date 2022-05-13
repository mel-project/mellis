#!/bin/bash
set -e

rustup default stable-i686-pc-windows-msvc 

cd `dirname "$(readlink -f "$0")"`


ISCC="./iscc/ISCC.exe"
rm -rfv iscc
mkdir -p iscc
unzip IS6.zip -d iscc
cargo install --locked --path ../ginkou-loader
cargo install --locked --path ../melwalletd
# (cd ../ginkou && npm ci && npm run build)

mkdir -p artifacts
curl https://ipfs.io/ipfs/QmYxsNyiskPyBZ9Cr8f4ARi1rRYKwphnfzncJGVSZMcNci > artifacts/vc_redist.x86.exe
cp $(which melwalletd) artifacts
cp $(which ginkou-loader) artifacts
sh -c "$ISCC setup.iss"
