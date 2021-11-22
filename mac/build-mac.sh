#!/bin/bash



MAC_ROOT=$( cd "$(dirname "$0")" ; pwd -P )
PROJECT_ROOT=$( cd $MAC_ROOT/.. ; pwd -P )
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
rm -rf dmg_setup
mkdir dmg_setup
mv ginkou.app dmg_setup

cd dmg_setup
ln -s /Applications

cd $MAC_ROOT
create-dmg $PROJECT_ROOT/builds/ginkou.dmg dmg_setup

rm -rf $RES/tmp


