// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "swift-armcknight",
    products: [
        .library(
            name: "swift-armcknight",
            targets: ["swift-armcknight"]),
    ],
    targets: [
        .target(
            name: "swift-armcknight"
	    ),
        .testTarget(
            name: "swift-armcknight-test",
            dependencies: ["swift-armcknight"]),
    ]
)