#!/bin/bash

test ! `which create-dmg` && brew install create-dmg

MAC_ROOT=$( cd "$(dirname "$0")" ; pwd -P )
PROJECT_ROOT=$( cd $MAC_ROOT/.. ; pwd -P )
RES=$MAC_ROOT/ginkou.app/Contents/MacOS/res


cd $MAC_ROOT
rm -rf ginkou.app
cp -r template.app ginkou.app
mkdir -p $RES/tmp

cargo install --locked --path $PROJECT_ROOT/ginkou-loader/ --root $RES/tmp
echo =======================
cargo install --locked --path $PROJECT_ROOT/melwalletd --root $RES/tmp
mv $RES/tmp/bin/* $RES
echo =======================
echo "Building ginkou"
if [[ ! -d $PROJECT_ROOT/ginkou-public ]]
then 
    cd $RES/tmp
    git clone $PROJECT_ROOT/ginkou 
    cd ginkou
    npm install
    npm run build
    npm run smui-theme-light
    mv public $PROJECT_ROOT/ginkou-public
else 
    echo "\`ginkou-public\` is available..."
    echo "not rebuilding ginkou and using \`ginkou-public\` instead"
fi

cp -r $PROJECT_ROOT/ginkou-public $RES/ginkou-public



cd $MAC_ROOT
rm -rf dmg_setup
mkdir dmg_setup
mv ginkou.app dmg_setup

cd dmg_setup
ln -s /Applications

cd $MAC_ROOT
rm -rf ginkou.dmg
create-dmg ginkou.dmg dmg_setup

rm -rf dmg_setup
rm -rf $RES/tmp


