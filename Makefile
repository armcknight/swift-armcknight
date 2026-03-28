.PHONY: build-macos
build-macos:
	swift build

.PHONY: build-ios
build-ios:
	swift build --sdk "$$(xcrun --sdk iphonesimulator --show-sdk-path)" --triple arm64-apple-ios17.0-simulator

.PHONY: build-all
build-all: build-macos build-ios
