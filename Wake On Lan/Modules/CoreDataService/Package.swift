// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreDataService",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CoreDataService",
            targets: ["CoreDataService"]
        )
    ],
    dependencies: [
        .package(path: "../SharedProtocolsAndModels"),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack", .upToNextMajor(from: "3.7.4")),
        .package(url: "https://github.com/Quick/Quick", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/Quick/Nimble", .upToNextMajor(from: "10.0.0"))
    ],
    targets: [
        .target(
            name: "CoreDataService",
            dependencies: [
                "SharedProtocolsAndModels",
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")
            ],
            path: "Sources",
            resources: [
                .process("Resources/HostsDataModel.xcdatamodeld")
            ]
        ),
        .testTarget(
            name: "CoreDataServiceTests",
            dependencies: [
                "CoreDataService",
                "Quick",
                "Nimble"
            ]
        )
    ]
)
