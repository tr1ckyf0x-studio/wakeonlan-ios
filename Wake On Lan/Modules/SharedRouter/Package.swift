// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedRouter",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SharedRouter",
            targets: ["SharedRouter"]
        )
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "SharedRouter",
            path: "Sources"
        )
    ]
)
