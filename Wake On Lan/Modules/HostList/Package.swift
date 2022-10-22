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
        .package(path: "../CoreDataService"),
        .package(path: "../SharedExtensions"),
        .package(path: "../SharedProtocolsAndModels"),
        .package(path: "../WakeOnLanService"),
        .package(path: "../WOLResources"),
        .package(path: "../WOLUIComponents"),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack", .upToNextMajor(from: "3.7.4")),
        .package(url: "https://github.com/ashleymills/Reachability.swift", .upToNextMajor(from: "5.1.0")),
        .package(url: "https://github.com/SnapKit/SnapKit", .upToNextMajor(from: "5.6.0"))
    ],
    targets: [
        .target(
            name: "HostList",
            dependencies: [
                "CoreDataService",
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
