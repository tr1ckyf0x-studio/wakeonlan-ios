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
        .package(path: "../WOLResources"),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack", .upToNextMajor(from: "3.8.0"))
    ],
    targets: [
        .target(
            name: "CoreDataService",
            dependencies: [
                "SharedProtocolsAndModels",
                "WOLResources",
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")
            ],
            resources: [
                .process("Resources/HostsDataModel.xcdatamodeld")
            ]
        ),
        .testTarget(
            name: "CoreDataServiceTests",
            dependencies: [
                "CoreDataService"
            ]
        )
    ]
)
