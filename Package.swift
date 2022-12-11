// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "swift-armcknight",
    products: [
        .library(
            name: "SwiftArmcknight",
            targets: ["SwiftArmcknight"]),
    ],
    targets: [
        .target(
            name: "SwiftArmcknight"),
        .testTarget(
            name: "SwiftArmcknightTest",
            dependencies: ["SwiftArmcknight"]),
    ]
)
