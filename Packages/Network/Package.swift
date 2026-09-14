// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Network",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Network",
            targets: ["Network"]
        )
    ],
    targets: [
        .target(
            name: "Network",
            publicHeadersPath: "include"
        ),
        .testTarget(
            name: "NetworkCoreTests",
            dependencies: ["Network"]
        ),
        .testTarget(
            name: "ExpenseRemoteTests",
            dependencies: ["Network"]
        )
    ]
)
