# Changelog

All notable changes to this project are documented here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] 2026-08-11

### Added

- Release automation: `make {patch,minor,major}` bumps `VERSION`, `make deploy`
  migrates this changelog, tags, and pushes, and CI publishes the GitHub release
  from the tagged section. Until now the package had no tags at all, so
  dependents had to pin a branch or a commit.

### Fixed

- The test target compiles and passes again. It had gone stale when the `Graph`
  and power set types moved into `SwiftArmcknightMath` without the test target
  gaining a dependency on it, and two `GraphTest` cases compared an
  `[NodeType]` against a `Set` by `hashValue`, which could never match. Nothing
  in the shipped libraries changed.
