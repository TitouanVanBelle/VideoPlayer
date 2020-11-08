// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VideoPlayer",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "VideoPlayer",
            targets: ["VideoPlayer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/PureLayout/PureLayout", .upToNextMajor(from: "3.1.6"))
    ],
    targets: [
        .target(
            name: "VideoPlayer",
            dependencies: [
                "PureLayout"
            ],
            resources: [.process("Resources")])
    ]
)
