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
        ),
        .library(
            name: "SharedProtocolsAndModelsMocks",
            targets: ["SharedProtocolsAndModelsMocks"]
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
            ]
        ),
        .target(
            name: "SharedProtocolsAndModelsMocks",
            dependencies: [
                "SharedProtocolsAndModels"
            ]
        )
    ]
)
