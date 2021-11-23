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


GINKOU_BRANCH=$(git checkout `(cd ../ginkou && git log --format='%H' -n 1)`)
WALLET_BRANCH=$(git checkout `(cd ../melwalletd && git log --format='%H' -n 1)`)
LOADER_BRANCH=$(git checkout `(cd ../ginkou-loader && git log --format='%H' -n 1)`)
e
flatpak-builder build org.themelio.Wallet-dev.yml --force-clean --user --install