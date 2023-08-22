// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Frameworks",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SharedExtensions",
            targets: ["SharedExtensions"]
        ),
        .library(
            name: "SharedProtocolsAndModels",
            targets: ["SharedProtocolsAndModels"]
        ),
        .library(
            name: "SharedProtocolsAndModelsMocks",
            targets: ["SharedProtocolsAndModelsMocks"]
        ),
        .library(
            name: "SharedRouter",
            targets: ["SharedRouter"]
        ),
        .library(
            name: "WOLResources",
            targets: ["WOLResources"]
        ),
        .library(
            name: "WOLResourcesMock",
            targets: ["WOLResourcesMock"]
        ),
        .library(
            name: "BundleInfoTestData",
            targets: ["BundleInfoTestData"]
        ),
        .library(
            name: "WOLUIComponents",
            targets: ["WOLUIComponents"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit", .upToNextMajor(from: "5.6.0")),
        .package(url: "https://github.com/ekazaev/route-composer", .upToNextMajor(from: "2.10.4"))

    ],
    targets: [
        .target(
            name: "SharedExtensions",
            dependencies: [
                "WOLResources"
            ]
        ),
        .target(
            name: "SharedProtocolsAndModels",
            dependencies: [
                "WOLResources"
            ]
        ),
        .target(
            name: "SharedProtocolsAndModelsMocks",
            dependencies: [
                "SharedProtocolsAndModels"
            ]
        ),
        .target(
            name: "SharedRouter",
            dependencies: [
                .product(name: "RouteComposer", package: "route-composer")
            ]
        ),
        .target(
            name: "WOLResources"
        ),
        .target(
            name: "WOLResourcesMock",
            dependencies: ["WOLResources"]
        ),
        .target(
            name: "BundleInfoTestData",
            dependencies: [
                "WOLResources"
            ]
        ),
        .target(
            name: "WOLUIComponents",
            dependencies: [
                "SharedProtocolsAndModels",
                "SharedExtensions",
                "SnapKit",
                "WOLResources"
            ]
        )
    ]
)
