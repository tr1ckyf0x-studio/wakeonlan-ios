// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HostList",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "HostList",
            targets: ["HostList"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../WOLResources"),
        .package(path: "../SharedModels"),
        .package(path: "../SharedProtocols"),
        .package(path: "../CoreDataService"),
        .package(path: "../WakeOnLanService"),
        .package(path: "../SharedExtensions"),
        .package(path: "../WOLUIComponents"),
        .package(path: "../AddHost"),
        .package(path: "../AboutScreen"),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack", from: "3.7.0"),
        .package(name: "Reachability", url: "https://github.com/ashleymills/Reachability.swift", from: "5.1.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.0"),
        .package(url: "https://github.com/hmlongco/Resolver", from: "1.4.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "HostList",
            dependencies: [
                "WOLResources",
                "SharedModels",
                "SharedProtocols",
                "CoreDataService",
                "WakeOnLanService",
                "SharedExtensions",
                "WOLUIComponents",
                "AddHost",
                "AboutScreen",
                "SnapKit",
                "Resolver",
                .product(name: "Reachability", package: "Reachability"),
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")
            ],
            path: "Sources")
    ]
)
