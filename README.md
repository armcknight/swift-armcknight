# `swift-armcknight`

A collection of Swift extensions.

## Development

`make help` lists every target. The common ones:

```
make build      # build for macOS
make build-all  # build for macOS and the iOS simulator
make test       # run the unit tests
```

## Releasing

`VERSION` is the source of truth. Bump it, then deploy — needs `vrsn` and
`prepare-release` on PATH, from the `armcknight/tools` cask:

```
make patch      # or minor / major — bumps VERSION and commits
make deploy     # migrates the changelog's Unreleased section, tags, pushes
```

Pushing the tag is what starts the release: GitHub Actions publishes the release
from that changelog section. There is no artifact to upload — dependents resolve
this package from the git tag, so the tag *is* the release. `make deploy-beta`
tags a release candidate instead, published as a prerelease.

# Thanks!

If this project helped you, please consider <a href="https://www.paypal.me/armcknight">leaving a tip</a> 🤗
