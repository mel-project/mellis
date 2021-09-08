#!/bin/sh
rm *.json
python3 ./flatpak-cargo-generator.py ./ginkou-loader/Cargo.lock -o loader-cargo-lock.json
python3 ./flatpak-cargo-generator.py ./melwalletd/Cargo.lock -o melwalletd-cargo-lock.json
python3 ./flatpak-node-generator.py npm -r ./ginkou/package-lock.json -o npm-lock.json
#flatpak-builder --force-clean --user --install output-build-dir org.themelio.Wallet.yml
flatpak-builder --install-deps-from flathub --gpg-sign=nullchinchilla@pm.me --force-clean --repo=repo build-dir org.themelio.Wallet.yml
