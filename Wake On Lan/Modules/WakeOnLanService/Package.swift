// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WakeOnLanService",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "WakeOnLanService",
            targets: ["WakeOnLanService"]
        )
    ],
    dependencies: [
        .package(path: "../SharedProtocolsAndModels"),
        .package(path: "../WOLResources")
    ],
    targets: [
        .target(
            name: "WakeOnLanService",
            dependencies: [
                "SharedProtocolsAndModels",
                "WOLResources"
            ],
            path: "Sources"
        )
    ]
)
