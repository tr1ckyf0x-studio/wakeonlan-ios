// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedRouter",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SharedRouter",
            targets: ["SharedRouter"]
        ),
        .library(
            name: "SharedRouterMock",
            targets: ["SharedRouterMock"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ekazaev/route-composer", .upToNextMajor(from: "2.8.3"))
    ],
    targets: [
        .target(
            name: "SharedRouter",
            dependencies: [
                .product(name: "RouteComposer", package: "route-composer")
            ],
            path: "Sources"
        )
    ]
)
