// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AboutScreen",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "AboutScreen",
            targets: ["AboutScreen"]
        )
    ],
    dependencies: [
        .package(path: "../SharedExtensions"),
        .package(path: "../SharedProtocolsAndModels"),
        .package(path: "../SharedRouter"),
        .package(path: "../WOLResources"),
        .package(path: "../WOLUIComponents"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.0")
    ],
    targets: [
        .target(
            name: "AboutScreen",
            dependencies: [
                "SharedExtensions",
                "SharedProtocolsAndModels",
                "SharedRouter",
                "SnapKit",
                "WOLResources",
                "WOLUIComponents"
            ],
            path: "Sources"
        )
    ]
)
