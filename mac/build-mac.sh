#!/bin/bash

set -ex 

# test ! `which create-dmg` && brew install create-dmg

# setup global state
MAC_ROOT=$( cd "$(dirname "$0")" ; pwd -P ) # The absolute path to this file
PROJECT_ROOT=$( cd $MAC_ROOT/.. ; pwd -P ) # The absolute path to ginkou-flatpak
RES=$MAC_ROOT/ginkou.app/Contents/MacOS/res # The absolue path to the (yet to be created) ginkou.app


# initialize ginkou.app as a clone of the template
cd $MAC_ROOT
rm -rf ginkou.app
cp -r template.app ginkou.app
mkdir -p $RES/tmp


# each of these build functions depends on the global state

build_rust () {
    # using absolute paths so order doesn't matter
    echo "Starting Rust installation"

    cargo install --locked --path $PROJECT_ROOT/ginkou-loader --root $RES/tmp

    echo =======================

    cargo install --locked --path $PROJECT_ROOT/melwalletd --root $RES/tmp

    echo =======================

    echo "Moving binaries to" $RES
    mv $RES/tmp/bin/* $RES

}

build_ginkou () {

    echo "Building ginkou"

    pushd $RES/tmp
        git clone $PROJECT_ROOT/ginkou 
        cd ginkou
        npm install
        npm run build
        npm run smui-theme-light
        cp -r public $RES/ginkou-public
    popd

}







while [[ "$#" -gt 0 ]]; do
    case $1 in
        -ns|--no-sass) 
            echo 'Skipping SASS build'
            SASS=`false`
            shift ;;
        -np|--no-pug) 
            echo 'Skipping pug build'
            PUG=`false`
            shift ;;
        -nr|--no-racket)
            echo 'Skipping racket build'
            RACKET=`false`
            shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
done
