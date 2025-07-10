// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "chordata",
    platforms: [
        .macOS(.v14),
        .iOS(.v16),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "chordata",
            targets: ["chordata"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swhitty/FlyingFox.git", .upToNextMajor(from: "0.22.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "chordata",
            dependencies: [
                .product(name: "FlyingFox", package: "FlyingFox"),
            ],
            resources: [
                .copy("assets"),
//                .process("app.js"),
//                .process("app.css"),
//                .copy("app_js.map")
            ]),
        .testTarget(
            name: "chordataTests",
            dependencies: ["chordata"]
        ),
    ]
)
