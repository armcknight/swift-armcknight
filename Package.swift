// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "swift-armcknight",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17),
    ],
    products: [
        .library(
            name: "SwiftArmcknight",
            targets: ["SwiftArmcknight"]),
        .library(
            name: "SwiftArmcknightUIKit",
            targets: ["SwiftArmcknightUIKit"]),
        .library(
            name: "SwiftArmcknightTesting",
            targets: ["SwiftArmcknightTesting"]),
    ],
    targets: [
        .target(
            name: "SwiftArmcknight"
        ),
        .target(
            name: "SwiftArmcknightUIKit",
            dependencies: ["SwiftArmcknight"]
        ),
        .target(
            name: "SwiftArmcknightTesting"
        ),
        .testTarget(
            name: "SwiftArmcknightTest",
            dependencies: ["SwiftArmcknight"]),
    ]
)
