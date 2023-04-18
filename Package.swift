// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "clipng",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.2"),
        .package(url: "https://github.com/carlynorama/SwiftLIBPNG.git", branch:"dev-for-CLI")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "clipng",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name:"SwiftLIBPNG", package: "SwiftLIBPNG")]),
        .testTarget(
            name: "clipngTests",
            dependencies: ["clipng"]),
    ]
)
