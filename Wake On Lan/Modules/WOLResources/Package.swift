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
        )
    ],
    targets: [
        .target(
            name: "WOLResources"
        )
    ]
)
