// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "bearhunter",
    platforms: [
        // TODO: port to other platforms (SPM and Cocoapods scanning are blockers due to shell-based algorithm)
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "bearhunterlib",
            targets: ["bearhunterlib"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMajor(from: "1.0.3")),
        .package(url: "https://github.com/kareman/SwiftShell.git", .upToNextMajor(from: "5.1.0")),
        .package(url: "https://github.com/tuist/XcodeProj.git", .upToNextMajor(from: "8.0.0")),
        .package(url: "https://github.com/Carthage/Carthage.git", .upToNextMajor(from: "0.9.4")),
        .package(url: "https://github.com/onevcat/Rainbow", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        .target(
            name: "bearhunterlib",
            dependencies: [
                "Rainbow",
                "SwiftShell",
                "XcodeProj",
                .product(name: "CarthageKit", package: "Carthage")
            ]
        ),
        .executableTarget(
            name: "bearhuntercli",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "bearhunterlib"
            ]
        ),
        .target(
            name: "testsCommon",
            dependencies: []
        ),
        .testTarget(
            name: "bearhunterlibTests",
            dependencies: ["bearhunterlib", "testsCommon"],
            resources: [.copy("TestDoubles")]
        ),
        .testTarget(
            name: "bearhuntercliTests",
            dependencies: ["testsCommon", "bearhuntercli"],
            resources: [.copy("TestDoubles")]
        )
    ]
)
