// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AddHost",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AddHost",
            targets: ["AddHost"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../WOLResources"),
        .package(path: "../SharedModels"),
        .package(path: "../SharedProtocols"),
        .package(path: "../CoreDataService"),
        .package(path: "../SharedExtensions"),
        .package(path: "../WOLUIComponents"),
        .package(path: "../RouterProtocol"),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack", from: "3.7.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.0"),
        .package(url: "https://github.com/hmlongco/Resolver", from: "1.4.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AddHost",
            dependencies: [
                "WOLResources",
                "SharedModels",
                "SharedProtocols",
                "CoreDataService",
                "SharedExtensions",
                "WOLUIComponents",
                "RouterProtocol",
                "SnapKit",
                "Resolver",
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")
            ],
            path: "Sources")
    ]
)
