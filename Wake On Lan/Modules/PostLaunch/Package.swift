// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PostLaunch",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "PostLaunch",
            targets: ["PostLaunch"]
        )
    ],
    dependencies: [
        .package(path: "../CoreDataService"),
        .package(path: "../SharedExtensions"),
        .package(path: "../SharedProtocolsAndModels"),
        .package(path: "../SharedRouter"),
        .package(path: "../WakeOnLanService"),
        .package(path: "../WOLResources"),
        .package(path: "../WOLUIComponents"),
        .package(url: "https://github.com/SnapKit/SnapKit", .upToNextMajor(from: "5.6.0"))
    ],
    targets: [
        .target(
            name: "PostLaunch",
            dependencies: [
                "CoreDataService",
                "SharedExtensions",
                "SharedProtocolsAndModels",
                "SharedRouter",
                "SnapKit",
                "WakeOnLanService",
                "WOLResources",
                "WOLUIComponents"
            ],
            path: "Sources"
        )
    ]
)
