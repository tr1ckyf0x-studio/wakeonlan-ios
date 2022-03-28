// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedProtocolsAndModels",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SharedProtocolsAndModels",
            targets: ["SharedProtocolsAndModels"]
        )
    ],
    dependencies: [
        .package(path: "../WOLResources")
    ],
    targets: [
        .target(
            name: "SharedProtocolsAndModels",
            dependencies: [
                "WOLResources"
            ],
            path: "Sources"
        )
    ]
)
