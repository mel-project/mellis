#!/bin/sh
rsync -az --info=progress2 --delete --rsync-path="sudo rsync" ./org.themelio.Wallet.flatpakref debian@web.themelio.org:/var/www/dl.themelio.org/ginkou-flatpak/
rsync -az --info=progress2 --delete --rsync-path="sudo rsync" ./repo/ debian@web.themelio.org:/var/www/dl.themelio.org/ginkou-flatpak/repo/
