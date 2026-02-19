// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Theme",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "Theme",
            targets: ["Theme"]
        ),
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../Localizations")
    ],
    targets: [
        .target(
            name: "Theme",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "Localizations", package: "Localizations")
            ],
            path: "Sources",
            resources: [
                .process("Colors/Colors.xcassets")
            ]
        )
    ]
)
