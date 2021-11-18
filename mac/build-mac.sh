#!/bin/bash


PROJECT_ROOT=$( cd "$(dirname "$0")/.." ; pwd -P )
MAC_ROOT=$( cd "$(dirname "$0")" ; pwd -P )
RES=$MAC_ROOT/ginkou.app/Contents/MacOS/res




cd $MAC_ROOT
rm -rf ginkou.app
cp -r template.app ginkou.app
mkdir $RES/tmp

cargo install --path $PROJECT_ROOT/ginkou-loader/ --root $RES/tmp
cargo install --path $PROJECT_ROOT/melwalletd --root $RES/tmp
mv $RES/tmp/bin/* $RES

cd $RES/tmp
git clone $PROJECT_ROOT/ginkou 
cd ginkou
npm install
npm run build
npm run smui-theme-light
mv public $RES/ginkou-public

cd $MAC_ROOT


rm -rf $RES/tmp


