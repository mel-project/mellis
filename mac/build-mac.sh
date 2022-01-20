#!/bin/bash

set -ex 

pwd


# test ! `which create-dmg` && brew install create-dmg

MAC_ROOT=$( cd "$(dirname "$0")" ; pwd -P )
PROJECT_ROOT=$( cd $MAC_ROOT/.. ; pwd -P )
RES=$MAC_ROOT/ginkou.app/Contents/MacOS/res


cd $MAC_ROOT
rm -rf ginkou.app
cp -r template.app ginkou.app
mkdir -p $RES/tmp


pushd $PROJECT_ROOT/ginkou-loader/ 
    cargo build --locked 
    ls -la target/debug
    # mv $PROJECT_ROOT/ginkou-loader/target/debug/ginkou-loader $RES/
popd 

echo =======================

# cargo install --locked --path $PROJECT_ROOT/melwalletd --root $RES/tmp
# mv $RES/tmp/bin/* $RES
ls -la $RES
ls -la $PROJECT_ROOT/ginkou-loader/target
echo =======================
exit 0
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




# setup a directory with the ginkou app
cd $MAC_ROOT
rm -rf dmg_setup
mkdir dmg_setup
mv ginkou.app dmg_setup


# add a sym link to applications users can drag ginkou into
cd dmg_setup
ln -s /Applications

# create the dmg
cd $MAC_ROOT
rm -rf ginkou.dmg
create-dmg ginkou.dmg dmg_setup

# delete artifacts
rm -rf dmg_setup
rm -rf $RES/tmp


