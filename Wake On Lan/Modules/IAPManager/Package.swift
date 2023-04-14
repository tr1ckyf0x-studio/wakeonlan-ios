// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IAPManager",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "IAPManager",
            targets: ["IAPManager"]
        )
    ],
    dependencies: [
        .package(path: "../SharedProtocolsAndModels")
    ],
    targets: [
        .target(
            name: "IAPManager",
            dependencies: [
                "SharedProtocolsAndModels"
            ]
        )
    ]
)
