// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "banderify",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.3")
    ],
    targets: [
        .executableTarget(
            name: "banderify",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "banderifyTests",
            dependencies: ["banderify"],
            resources: [.copy("TestDoubles")]
        )
    ]
)
