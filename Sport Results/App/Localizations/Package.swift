// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Localizations",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "Localizations",
            targets: ["Localizations"]
        ),
    ],
    targets: [
        .target(
            name: "Localizations",
            path: "Sources",
            resources: [.process("Resources")]
        )
    ]
)
