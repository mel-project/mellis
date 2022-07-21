#!/bin/bash

START_TIME=$(date +%s)

if [ -n "$MELLIS_DEBUG" ]; then
  set -x
fi

set_build_type() {
  if [ -z "$MELLIS_RELEASE_BUILD" ]; then
    MELLIS_CARGO_BUILD_TARGET=debug
  else
    MELLIS_CARGO_BUILD_TARGET=release
  fi
}

build_ginkou_loader() {
  if [ -z "$MELLIS_RELEASE_BUILD" ]; then
    echo "Building development Ginkou-Loader"

    cargo build --locked --manifest-path ginkou-loader/Cargo.toml
  else
    echo "Building release Ginkou-Loader"

    cargo build --release --locked --manifest-path ginkou-loader/Cargo.toml
  fi


  rm -rf /tmp/ginkou-loader.tar.gz

  rm -rf ginkou-loader-archive

  mkdir ginkou-loader-archive

  mv ginkou-loader/target/${MELLIS_CARGO_BUILD_TARGET}/ginkou-loader ginkou-loader-archive/ginkou-loader

  tar -czvf /tmp/ginkou-loader.tar.gz ginkou-loader-archive
}

build_melwalletd() {
  if [ -z "$MELLIS_RELEASE_BUILD" ]; then
    echo "Building development MelwalletD"

    cargo build --locked --manifest-path melwalletd/Cargo.toml
  else
    echo "Building release MelwalletD"

    cargo build --release --locked --manifest-path melwalletd/Cargo.toml
  fi


  rm -rf /tmp/melwalletd.tar.gz

  rm -rf melwalletd-archive

  mkdir melwalletd-archive

  mv melwalletd/target/${MELLIS_CARGO_BUILD_TARGET}/melwalletd melwalletd-archive/melwalletd

  tar -czvf /tmp/melwalletd.tar.gz melwalletd-archive
}

build_ginkou() {
  yarn install --prefer-offline --cwd ginkou

  if [ -z "$MELLIS_RELEASE_BUILD" ]; then
    echo "Building development Wallet"
    env BUILD=development npm run build --prefix ginkou
  else
    echo "Building production Wallet"
    env BUILD=production npm run build --prefix ginkou
  fi


  rm -rf /tmp/public.tar.gz

  tar -czvf /tmp/public.tar.gz -C ginkou public
}

build_dmg_prerequisites() {
  if [ -n "$MELLIS_INSTALL_PREREQUISITES" ]; then
    rm -rf /tmp/libdmg-hfsplus

    rm -rf dmg

    pushd /tmp
      git clone https://github.com/fanquake/libdmg-hfsplus
    popd

    pushd /tmp/libdmg-hfsplus
      cmake . -B build
      make -C build/dmg -j8
    popd

    mv /tmp/libdmg-hfsplus/build/dmg/dmg .

    rm -rf /tmp/libdmg-hfsplus
  fi
}

build_dmg() {
  if [ -n "$MELLIS_BUILD_DMG" ]; then
    rm -rf mellis.app

    rm -rf mellis-uncompressed.dmg

    rm -rf top-level

    cp -r mac/template.app mellis.app

    mkdir mellis.app/Contents/MacOS/res

    cp ginkou-loader-archive/ginkou-loader mellis.app/Contents/MacOS/res/

    cp melwalletd-archive/melwalletd mellis.app/Contents/MacOS/res/

    cp -r ginkou/public mellis.app/Contents/MacOS/res/ginkou-public

    mkdir top-level

    mv mellis.app top-level/mellis.app

    ln -s /Applications top-level/

    genisoimage -V mellis -D -R -apple -no-pad -o mellis-uncompressed.dmg top-level

    ./dmg mellis-uncompressed.dmg mellis.dmg

    rm -rf mellis-uncompressed.dmg
  fi
}

fetch_windows_prerequisites() {
  if [ -n "$MELLIS_INSTALL_PREREQUISITES" ]; then
    rm -rf IS6.zip

    rm -rf iscc

    wget https://raw.githubusercontent.com/themeliolabs/docker-images/master/wine/IS6.zip

    unzip IS6.zip -d iscc
  fi
}

build_windows_installer() {
  rm -rf windows/artifacts

  rm -rf windows/Output

  mkdir -p windows/artifacts

  rustup target add i686-pc-windows-gnu

  cargo build --locked --target=i686-pc-windows-gnu --manifest-path ginkou-loader/Cargo.toml

  cp ginkou-loader/target/i686-pc-windows-gnu/${MELLIS_CARGO_BUILD_TARGET}/ginkou-loader.exe windows/artifacts/

  wine iscc/ISCC.exe windows/setup.iss
}

build_flatpak() {
  rm -rf /tmp/icons.tar.gz

  rm -rf build

  rm -rf export

  tar -czvf /tmp/icons.tar.gz -C flatpak icons

  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

  flatpak-builder build flatpak/org.themelio.Wallet-ci.yml --force-clean --install-deps-from flathub

  flatpak build-export export build

  flatpak build-bundle export mellis.flatpak org.themelio.Wallet
}

git submodule update --init --recursive

set_build_type

build_dmg_prerequisites

fetch_windows_prerequisites

build_ginkou_loader

build_melwalletd

build_ginkou

build_dmg

build_windows_installer


echo

if [ -n "$MELLIS_BUILD_DMG" ]; then
  echo "The MacOS DMG is available at mellis.dmg"
fi

echo "The windows installer is available at windows/Output/mellis-windows-setup.exe"

echo "The flatpak is available at mellis.flatpak"


END_TIME=$(date +%s)

SCRIPT_DURATION=$((END_TIME - START_TIME))

echo "Script completed in: ${SCRIPT_DURATION} seconds"