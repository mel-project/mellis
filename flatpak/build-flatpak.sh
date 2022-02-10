#!/bin/bash


# Before merge to master run `build-flatpak --manifest` and `build-flatpak --manifest --release`
if [ -n "${ARCH_FIRST_RUN}" ]; then
  sudo pacman -S flatpak flatpak-builder elfutils patch
elif [ -n "${DEBIAN_FIRST_RUN}" ]; then
  sudo apt update
  env DEBIAN_FRONTEND=noninteractive sudo apt -y install flatpak flatpak-builder libgtk-3-dev libwebkit2gtk-4.0-dev
fi;

export RELEASE_FLAG=""
export USER_FLAG=""
export TARGET="debug"

ONLY_MANIFEST=0
INSTALL_MANIFEST=""
MANIFEST_FILE="org.themelio.Wallet-dev.yml"


set -ex


while [[ "$#" -gt 0 ]]; do
  case $1 in
    -i|--install)
      INSTALL_MANIFEST="--install"
      shift
      ;;
    -r|--release)
      RELEASE_FLAG="--release"
      TARGET="release"
      MANIFEST_FILE="org.themelio.Wallet.yml"
      shift
      ;;
    -u|--user)
      USER_FLAG="--user"
      shift
      ;;
    -m|--manifest)
      ONLY_MANIFEST=1
      shift
      ;;
    -h|--help)
      echo "By default the script generates org.themelio.Wallet-dev.yml and installs all it's dependencies, you can additionally specify,"
      echo
      echo "-i --install\t\t installs flatpak manifest, by default thats org.themelio.Wallet-dev.yml (changed by -r)"
      echo "-r --release\t\t build rust as release, this also generates org.themelio.Wallet.yml"
      echo "-u --user\t\t adds --user flag to flatpak-builder"
      echo "-m --manifest\t\t build manifest only"
      echo "-h --help\t\t this help message"


      exit 1
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

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
(( $ONLY_MANIFEST  < 1)) && flatpak-builder build $MANIFEST_FILE --force-clean $INSTALL_MANIFEST --install-deps-from flathub $USER_FLAG
