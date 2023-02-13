// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EventKitHelper",
    platforms: [
        .macOS("15"),
    ],
    products: [
        .executable(
            name: "EventKitHelper", targets: ["EventKitHelper"]
        ),
    ],
    targets: [
        .target(name: "EventKitHelper")
    ]
)
