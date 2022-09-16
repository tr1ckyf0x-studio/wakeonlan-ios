// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WakeOnLanService",
    platforms: [.iOS(.v13)],
    products: [
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
        .package(path: "../SharedProtocolsAndModels")
    ],
    targets: [
        .target(
            name: "WakeOnLanService",
            dependencies: [
                "SharedProtocolsAndModels"
            ]
        ),
        .target(
            name: "WakeOnLanServiceMock",
            dependencies: [
                "WakeOnLanService",
                "SharedProtocolsAndModels"
            ]
        ),
        .testTarget(
            name: "WakeOnLanServiceTests",
            dependencies: [
                "WakeOnLanService",
                "WakeOnLanServiceMock",
                "SharedProtocolsAndModels"
            ]
        )
    ]
)
