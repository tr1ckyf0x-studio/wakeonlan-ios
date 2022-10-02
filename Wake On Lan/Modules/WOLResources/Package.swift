// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WOLResources",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
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
            targets: ["BundleInfoTestData"])
    ],
    targets: [
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
        )
    ]
)
