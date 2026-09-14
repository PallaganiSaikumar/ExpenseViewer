// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Expense",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Expense",
            targets: ["Expense"]
        )
    ],
    dependencies: [
        .package(path: "../Network")
    ],
    targets: [
        .target(
            name: "Expense",
            dependencies: [
                .product(name: "Network", package: "Network")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "ExpenseDomainTests",
            dependencies: ["Expense"]
        ),
        .testTarget(
            name: "ExpenseDataTests",
            dependencies: [
                "Expense",
                .product(name: "Network", package: "Network")
            ]
        ),
        .testTarget(
            name: "ExpensePresentationTests",
            dependencies: ["Expense"]
        ),
        .testTarget(
            name: "ExpenseTests",
            dependencies: ["Expense"]
        )
    ]
)
