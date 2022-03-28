// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HostList",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "HostList",
            targets: ["HostList"]
        )
    ],
    dependencies: [
        .package(path: "../AboutScreen"), // TODO: Replace with protocol dependency
        .package(path: "../AddHost"), // TODO: Replace with protocol dependency
        .package(path: "../CoreDataService"),
        .package(path: "../SharedExtensions"),
        .package(path: "../SharedProtocolsAndModels"),
        .package(path: "../WakeOnLanService"),
        .package(path: "../WOLResources"),
        .package(path: "../WOLUIComponents"),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack", from: "3.7.0"),
        .package(url: "https://github.com/ashleymills/Reachability.swift", from: "5.1.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.0"),
        .package(url: "https://github.com/hmlongco/Resolver", from: "1.4.0")
    ],
    targets: [
        .target(
            name: "HostList",
            dependencies: [
                "AddHost",
                "AboutScreen",
                "CoreDataService",
                "Resolver",
                "SnapKit",
                "SharedExtensions",
                "SharedProtocolsAndModels",
                "WakeOnLanService",
                "WOLResources",
                "WOLUIComponents",
                .product(name: "Reachability", package: "Reachability.swift"),
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")
            ],
            path: "Sources"
        )
    ]
)
