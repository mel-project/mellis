# Ginkou Flatpak
Flatpak package for the Ginkou wallet

## Install
The package is not yet listed on flathub.

To install, simply clone this repository and run the build script.

```bash
git clone https://github.com/themeliolabs/ginkou-flatpak
cd ginkou-flatpak
sh build-local.sh
```

## Run

```bash
flatpak run org.themelio.Wallet
```

If this doesn't work on your system, or if you have any feedback, please [open an issue](https://github.com/themeliolabs/ginkou-flatpak/issues/new) and we'll get to it :)


## Local Development

First, you will need to edit `org.themelio.Wallet-local-dev.yml` and change the lines that read:
```
- "git checkout DEVELOPMENT-BRANCH-GOES-HERE"
```
to whichever branch(es) you are working on, and uncomment those lines.



If it is the first time you have run the build script, you will need to use an operating-system-specific environment variable:

```
env DEBIAN_FIRST_RUN=true ./build-local.sh
```

Or:

```
env NIXOS_FIRST_RUN=true ./build-local.sh
```


Otherwise, just run:

```
./build-local.sh
```
