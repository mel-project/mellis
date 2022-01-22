#!/bin/bash


# setup global state
MAC_ROOT=$( cd "$(dirname "$0")" ; pwd -P ) # The absolute path to this files parent
PROJECT_ROOT=$( cd $MAC_ROOT/.. ; pwd -P ) # The absolute path to ginkou-flatpak
RES=$MAC_ROOT/ginkou.app/Contents/MacOS/res # The absolue path to the (yet to be created) ginkou.app
ARTIFACTS=$MAC_ROOT/artifacts
TMP=$MAC_ROOT/tmp
# each of these functions depends on global state 

# the install functions build and install the artifacts into $ARTIFACTS

install_ginkou_loader () {
    echo "Starting Rust installation"
    cargo install --locked --path $PROJECT_ROOT/ginkou-loader --root $TMP
    mv $TMP/bin/ginkou-loader $ARTIFACTS
    echo =======================


}


install_melwalletd () {
    cargo install --locked --path $PROJECT_ROOT/melwalletd --root $TMP
    mv $TMP/bin/melwalletd $ARTIFACTS
    echo =======================

}



install_ginkou () {

    echo "Building ginkou"

    pushd $TMP
        git clone $PROJECT_ROOT/ginkou 
        cd ginkou
        npm install
        npm run build
        npm run smui-theme-light
        mv public $ARTIFACTS/ginkou-public
    popd

}

# clean up any old app, clone the temp app, and copy the artifacts to $RES
build_app (){
    
    rm -rf ginkou.app
    cp -r $MAC_ROOT/template.app ginkou.app
    mkdir -p $RES
    cp -r $ARTIFACTS/* $RES

}

build_dmg () {
# setup a directory containing ginkou.app
    pushd $MAC_ROOT
        rm -rf dmg_setup
        mkdir dmg_setup
        mv ginkou.app dmg_setup


        # add a sym link to applications into which users may drag ginkou.app
        cd dmg_setup
        ln -s /Applications

        # create the dmg
        cd $MAC_ROOT
        rm -rf ginkou.dmg
        create-dmg ginkou.dmg dmg_setup

        # delete artifacts
        rm -rf dmg_setup
        rm -rf $RES/tmp
    popd



}


_GINKOU_LOADER=0
_MELWALLETD=0
_GINKOU=0
_APP=0
_DMG=0



# if any argument is specified then only that build process is run
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -gl|--ginkou-loader) 
            _GINKOU_LOADER=1
            shift ;;
        -mwd|--melwalletd) 
            _MELWALLETD=1
            shift ;;
        -g|--ginkou)
            _GINKOU=1
            shift ;;
        -A|--app)
            _APP=1
            shift ;;
        -D|--dmg)
            _DMG=1
            shift;;

        --clean)
            rm -rf $ARTIFACTS
            shift;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
done


set -ex 

[[ ! -d $ARTIFACTS ]] && mkdir $ARTIFACTS
ls
# test ! `which create-dmg` && brew install create-dmg

rm -rf $TMP
mkdir $TMP

[[ ! -z 1 ]] && echo it was

[[ -z $_GINKOU_LOADER ]] && install_ginkou_loader
[[ -z $_MELWALLETD ]] && install_melwalletd
[[ -z $_GINKOU ]] && install_ginkou
rm -rf $TMP
[[ -z $_APP ]] && build_app
[[ -z $_DMG ]] && build_dmg

echo "DONE"