# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Release automation: `make {patch,minor,major}` bumps `VERSION`, `make deploy`
  migrates this changelog, tags, and pushes, and CI publishes the GitHub release
  from the tagged section. Until now the package had no tags at all, so
  dependents had to pin a branch or a commit.
