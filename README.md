# Ginkou-Flatpak

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
