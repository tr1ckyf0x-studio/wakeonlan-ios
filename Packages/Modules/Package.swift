// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PostLaunch",
            targets: ["PostLaunch"]
        ),
        .library(
            name: "AboutScreen",
            targets: ["AboutScreen"]
        ),
        .library(
            name: "AddHost",
            targets: ["AddHost"]
        ),
        .library(
            name: "HostList",
            targets: ["HostList"]
        ),
        .library(
            name: "CoreDataService",
            targets: ["CoreDataService"]
        ),
        .library(
            name: "WakeOnLanService",
            targets: ["WakeOnLanService"]
        ),
        .library(
            name: "WakeOnLanServiceMock",
            targets: ["WakeOnLanServiceMock"]
        )
    ],
    dependencies: [
        .package(path: "../Frameworks"),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack", .upToNextMajor(from: "3.8.1")),
        .package(url: "https://github.com/ashleymills/Reachability.swift", .upToNextMajor(from: "5.1.0")),
        .package(url: "https://github.com/SnapKit/SnapKit", .upToNextMajor(from: "5.6.0")),
        .package(url: "https://github.com/Quick/Quick", .upToNextMajor(from: "7.2.0")),
        .package(url: "https://github.com/Quick/Nimble", .upToNextMajor(from: "12.2.0"))
    ],
    targets: [
        .target(
            name: "PostLaunch",
            dependencies: [
                "AddHost",
                "SnapKit",
                "CoreDataService",
                .product(
                    name: "SharedRouter",
                    package: "Frameworks"
                ),
                .product(
                    name: "WOLResources",
                    package: "Frameworks"
                )
            ]
        ),
        .target(
            name: "AboutScreen",
            dependencies: [
                .product(name: "SharedExtensions", package: "Frameworks"),
                .product(name: "SharedProtocolsAndModels", package: "Frameworks"),
                "SnapKit",
                .product(name: "WOLUIComponents", package: "Frameworks"),
                .product(name: "WOLResources", package: "Frameworks"),
                .product(name: "SharedRouter", package: "Frameworks")
            ]
        ),
        .testTarget(
            name: "AboutScreenTests",
            dependencies: [
                "AboutScreen",
                .product(
                    name: "BundleInfoTestData",
                    package: "Frameworks"
                ),
                .product(
                    name: "WOLResourcesMock",
                    package: "Frameworks"
                )
            ]
        ),
        .target(
            name: "AddHost",
            dependencies: [
                "CoreDataService",
                "SnapKit",
                .product(name: "SharedExtensions", package: "Frameworks"),
                .product(name: "SharedProtocolsAndModels", package: "Frameworks"),
                .product(name: "WOLResources", package: "Frameworks"),
                .product(name: "WOLUIComponents", package: "Frameworks"),
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack"),
                .product(
                    name: "SharedRouter",
                    package: "Frameworks"
                )
            ]
        ),
        .testTarget(
            name: "AddHostTests",
            dependencies: [
                "AddHost",
                "Quick",
                "Nimble"
            ]
        ),
        .target(
            name: "HostList",
            dependencies: [
                "CoreDataService",
                "SnapKit",
                .product(name: "SharedExtensions", package: "Frameworks"),
                .product(name: "SharedProtocolsAndModels", package: "Frameworks"),
                "WakeOnLanService",
                .product(name: "WOLResources", package: "Frameworks"),
                .product(name: "WOLUIComponents", package: "Frameworks"),
                .product(name: "SharedRouter", package: "Frameworks"),
                .product(name: "Reachability", package: "Reachability.swift"),
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")
            ]
        ),
        .target(
            name: "CoreDataService",
            dependencies: [
                .product(name: "SharedProtocolsAndModels", package: "Frameworks"),
                .product(name: "WOLResources", package: "Frameworks"),
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
        ),
        .target(
            name: "WakeOnLanService",
            dependencies: [
                .product(name: "SharedProtocolsAndModels", package: "Frameworks")
            ]
        ),
        .target(
            name: "WakeOnLanServiceMock",
            dependencies: [
                "WakeOnLanService",
                .product(name: "SharedProtocolsAndModels", package: "Frameworks")
            ]
        ),
        .testTarget(
            name: "WakeOnLanServiceTests",
            dependencies: [
                "WakeOnLanService",
                "WakeOnLanServiceMock",
                .product(name: "SharedProtocolsAndModels", package: "Frameworks")
            ]
        )
    ]
)
