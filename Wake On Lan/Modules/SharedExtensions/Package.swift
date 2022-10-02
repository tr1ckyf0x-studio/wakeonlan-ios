// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedExtensions",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SharedExtensions",
            targets: ["SharedExtensions"]
        )
    ],
    dependencies: [
        .package(path: "../WOLResources")
    ],
    targets: [
        .target(
            name: "SharedExtensions",
            dependencies: [
                "WOLResources"
            ]
        )
    ]
)
