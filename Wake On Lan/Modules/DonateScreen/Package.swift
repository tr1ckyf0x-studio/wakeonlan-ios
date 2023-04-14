// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DonateScreen",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "DonateScreen",
            targets: ["DonateScreen"]
        )
    ],
    dependencies: [
        .package(path: "../SharedRouter"),
        .package(path: "../WOLResources"),
        .package(path: "../WOLUIComponents"),
        .package(path: "../SharedProtocolsAndModels"),
        .package(path: "../IAPManager"),
        .package(url: "https://github.com/SnapKit/SnapKit", .upToNextMajor(from: "5.6.0")),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack", .upToNextMajor(from: "3.8.0"))
    ],
    targets: [
        .target(
            name: "DonateScreen",
            dependencies: [
                "SharedRouter",
                "WOLResources",
                "WOLUIComponents",
                "SharedProtocolsAndModels",
                "IAPManager",
                "SnapKit",
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")
            ]
        )
    ]
)
