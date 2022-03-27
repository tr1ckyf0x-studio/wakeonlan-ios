// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AddHost",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "AddHost",
            targets: ["AddHost"]
        )
    ],
    dependencies: [
        .package(path: "../CoreDataService"),
        .package(path: "../SharedExtensions"),
        .package(path: "../SharedProtocolsAndModels"),
        .package(path: "../SharedRouter"),
        .package(path: "../WOLResources"),
        .package(path: "../WOLUIComponents"),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack", from: "3.7.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.0"),
        .package(url: "https://github.com/hmlongco/Resolver", from: "1.4.0")
    ],
    targets: [
        .target(
            name: "AddHost",
            dependencies: [
                "CoreDataService",
                "Resolver",
                "SnapKit",
                "SharedExtensions",
                "SharedProtocolsAndModels",
                "SharedRouter",
                "WOLResources",
                "WOLUIComponents",
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")
            ],
            path: "Sources"
        )
    ]
)
