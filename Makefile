# A bare VERSION file is the single source of truth for the release version
# (bumped by vrsn, read by prepare-release). A library has no `static let
# version` to hang it off, the way the CLI packages do.
VERSION_FILE = VERSION

.PHONY: help build build-macos build-ios build-all test patch minor major deploy-beta deploy

.DEFAULT_GOAL := help

help: ## Show this help
	@echo "swift-armcknight — available make targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| sort \
		| awk 'BEGIN {FS = ":.*?## "} {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

# MARK: - Dev tooling

build: build-macos ## Build for the host platform

build-macos: ## Build for macOS
	swift build

build-ios: ## Build for the iOS simulator
	swift build --sdk "$$(xcrun --sdk iphonesimulator --show-sdk-path)" --triple arm64-apple-ios17.0-simulator

build-all: build-macos build-ios ## Build for macOS and the iOS simulator

test: ## Run the unit tests
	swift test

# MARK: - Releasing
#
# `make {patch,minor,major}` bumps VERSION with vrsn. Then `make deploy` runs
# prepare-release, which migrates the CHANGELOG [Unreleased] section into a dated
# version section, commits, tags, and pushes. GitHub Actions picks up the tag and
# publishes the GitHub release from that changelog section.
#
# There is no binary to ship: dependents resolve the package from the git tag, so
# tagging *is* the release.
#
# Requires `vrsn` + `prepare-release` on PATH (from the armcknight/tools cask).

patch: ## Bump the patch version (x.y.Z) and commit
	vrsn patch -f $(VERSION_FILE) --commit

minor: ## Bump the minor version (x.Y.0) and commit
	vrsn minor -f $(VERSION_FILE) --commit

major: ## Bump the major version (X.0.0) and commit
	vrsn major -f $(VERSION_FILE) --commit

# Tags an RC of the current version. The RC number is auto-incremented from the
# changelog's consecutive RC sections, so this can run repeatedly to ship rc.1,
# rc.2, and so on without re-bumping the version.
deploy-beta: ## Migrate the changelog, tag an RC, and push
	prepare-release rc --file $(VERSION_FILE) --push

deploy: ## Migrate the changelog, tag, and push the release
	prepare-release --file $(VERSION_FILE) --push
