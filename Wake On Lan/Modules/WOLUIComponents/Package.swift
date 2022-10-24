// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WOLUIComponents",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "WOLUIComponents",
            targets: ["WOLUIComponents"]
        )
    ],
    dependencies: [
        .package(path: "../SharedExtensions"),
        .package(path: "../SharedProtocolsAndModels"),
        .package(path: "../WOLResources"),
        .package(url: "https://github.com/SnapKit/SnapKit", .upToNextMajor(from: "5.6.0"))
    ],
    targets: [
        .target(
            name: "WOLUIComponents",
            dependencies: [
                "SharedProtocolsAndModels",
                "SharedExtensions",
                "SnapKit",
                "WOLResources"
            ]
        )
    ]
)
