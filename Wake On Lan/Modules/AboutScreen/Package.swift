// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AboutScreen",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "AboutScreen",
            targets: ["AboutScreen"]
        )
    ],
    dependencies: [
        .package(path: "../SharedExtensions"),
        .package(path: "../SharedProtocolsAndModels"),
        .package(path: "../SharedRouter"),
        .package(path: "../WOLResources"),
        .package(path: "../WOLUIComponents"),
        .package(url: "https://github.com/SnapKit/SnapKit", .upToNextMajor(from: "5.6.0"))
    ],
    targets: [
        .target(
            name: "AboutScreen",
            dependencies: [
                "SharedExtensions",
                "SharedProtocolsAndModels",
                "SnapKit",
                "WOLUIComponents",
                .product(
                    name: "WOLResources",
                    package: "WOLResources"
                ),
                .product(
                    name: "SharedRouter",
                    package: "SharedRouter"
                )
            ]
        ),
        .testTarget(
            name: "AboutScreenTests",
            dependencies: [
                "AboutScreen",
                .product(
                    name: "BundleInfoTestData",
                    package: "SharedExtensions"
                ),
                .product(
                    name: "WOLResourcesMock",
                    package: "WOLResources"
                )
            ]
        )
    ]
)
