#!/bin/sh

if [ -n "${ARCH_FIRST_RUN}" ]; then
  sudo pacman -S flatpak flatpak-builder elfutils patch
  sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  sudo flatpak install -y flathub org.gnome.Sdk/x86_64/40 org.gnome.Platform/x86_64/40 flathub org.freedesktop.Sdk.Extension.rust-stable//20.08 flathub org.freedesktop.Sdk.Extension.node14//20.08
elif [ -n "${DEBIAN_FIRST_RUN}" ]; then
  sudo apt update
  env DEBIAN_FRONTEND=noninteractive sudo apt -y install flatpak flatpak-builder libgtk-3-dev libwebkit2gtk-4.0-dev
  sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  sudo flatpak install -y flathub org.gnome.Sdk/x86_64/40 org.gnome.Platform/x86_64/40 flathub org.freedesktop.Sdk.Extension.rust-stable//20.08 flathub org.freedesktop.Sdk.Extension.node14//20.08
elif [ -n "${NIXOS_FIRST_RUN}" ]; then
  sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  sudo flatpak install -y flathub org.gnome.Sdk/x86_64/40 org.gnome.Platform/x86_64/40 flathub org.freedesktop.Sdk.Extension.rust-stable//20.08 flathub org.freedesktop.Sdk.Extension.node14//20.08
fi


export RELEASE_FLAG=""
export TARGET="debug"
MANIFEST_FILE="org.themelio.Wallet-dev.yml"

while getopts "irh" opt; do
  case $opt in
    i)
      INSTALL_MANIFEST=1
      ;;
    r)
      RELEASE_FLAG="--release"
      TARGET="release"
      MANIFEST_FILE="org.themelio.Wallet.yml"
      ;;
    h)
      echo "By default the script generates org.themelio.Wallet-dev.yml, you can additionally specify: "
      echo
      echo "-i\t\t installs flatpak manifest, by default thats org.themelio.Wallet-dev.yml (changed by -r)"
      echo "-r\t\t build rust as release, this also generates org.themelio.Wallet.yml"
      echo "-h\t\t this help message"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      exit 1
      ;;
  esac
done

export GINKOU_BRANCH=`(cd ../ginkou && git log --format='%H' -n 1)`
export WALLET_BRANCH=`(cd ../melwalletd && git log --format='%H' -n 1)`
export LOADER_BRANCH=`(cd ../ginkou-loader && git log --format='%H' -n 1)`

cat org.themelio.Wallet-dev-template.yml | 
envsubst '$GINKOU_BRANCH $WALLET_BRANCH $LOADER_BRANCH $RELEASE_FLAG $TARGET' > $MANIFEST_FILE;

if [ -n "${INSTALL_MANIFEST}" ]; then 
  flatpak-builder build $MANIFEST_FILE --force-clean --user --install
fi