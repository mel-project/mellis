#!/bin/sh

if [ -n "${DEBIAN_FIRST_RUN}" ]; then
  sudo apt update
  env DEBIAN_FRONTEND=noninteractive sudo apt -y install flatpak flatpak-builder libgtk-3-dev libwebkit2gtk-4.0-dev
  sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  sudo flatpak install -y flathub org.gnome.Sdk/x86_64/40
  sudo flatpak install -y flathub org.gnome.Platform/x86_64/40 flathub org.freedesktop.Sdk.Extension.rust-stable//20.08 flathub org.freedesktop.Sdk.Extension.node14//20.08
elif [ -n "${NIXOS_FIRST_RUN}" ]; then
  exec themelio-node --database {{ pkg.svc_data_path }}/main.sqlite3 --listen 0.0.0.0:{{ cfg.port }} --advertise "${ADVERTISE_MANUAL}":{{ cfg.port }}
fi

flatpak-builder build org.themelio.Wallet-local-dev.yml --force-clean --user