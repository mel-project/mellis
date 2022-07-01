# Local Development

## Prerequisites

On Arch, run:
```bash
sudo pacman -S lzlib mingw-w64 flatpak flatpak-builder cmake mingw-w64-gcc mingw-w64-winpthreads cdrtools
```

On Debian/Ubuntu, run:
```bash
sudo apt -y install zlib1g-dev build-essential cmake genisoimage
```

## Environment Variables And Useage

To operate this script, these environment variables exist:
```bash
MELLIS_DEBUG
MELLIS_INSTALL_PREREQUISITES
MELLIS_RELEASE_BUILD
MELLIS_BUILD_DMG
```

To show all output, run:
```bash
env MELLIS_DEBUG=true ./build-local.sh
```

If it is the first time you are running the script, run:
```bash
env MELLIS_INSTALL_PREREQUISITES=true ./build-local.sh
```


To run a release/production build, run:
```bash
env MELLIS_RELEASE_BUILD=true ./build-local.sh
```

And if you testing for MacOS, run:
```bash
env MELLIS_BUILD_DMG=true ./build-local.sh
```


