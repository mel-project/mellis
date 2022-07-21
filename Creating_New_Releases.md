# Creating New Releases

## Pull Requests

Everything is controlled via pull requests.


Releases are controlled via two markdown files:
- The [changelog](CHANGELOG.md)
- The [latest version](LATEST_VERSION.md)



Those two files are the only things that need to be updated to create a new release.

In the pull request, an automatically generated comment will give a link like this:
```
The draft URL is: https://github.com/themeliolabs/mellis/releases/tag/untagged-hash-goes-here
```

A draft release will be created that is based off of the branch that creates the pull request.
The version from the top line of the `LATEST_VERSION.md` file will be the suffix.
So, `branch_name-version` will look like:
```
meade-self-hosted-runner-v0.3.6
```


## Artifacts

In each pull request/release, the following artifacts will be created:
- `mellis-windows-setup.exe`
- `mellis.dmg`
- `mellis.flatpak`

Before merging any pull request, these files will need to be installed an run to verify functionality manually.

The full changelog (CHANGELOG.md) will have contents similar to this:
```
## v0.3.6

### Fixes

* Added debug logs export for easier debugging
* Added proper icons on all platforms
* Fixed miscellaneous UI bugs

## v0.3.2

### Fixes

* Minor bugfixes

## v0.3.0

### New Features
* Adds support for key export and import

### Fixes

* Race conditions leading to strange freezes and errors
* Issues with unlocking the wallet.


##  v0.2.10

### Fixes

* Made the window smaller to not run off-screen on small screens

...
```

And the latest version markdown (LATEST_VERSION.md) will *only* have the top section from the full changelog:
```
## v0.3.6

### Fixes

* Added debug logs export for easier debugging
* Added proper icons on all platforms
* Fixed miscellaneous UI bugs
```