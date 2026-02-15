// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Generic",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "Architecture",
            targets: ["Architecture"]
        ),
        .library(
            name: "ModelConverter",
            targets: ["ModelConverter"]
        ),
        .library(
            name: "Navigation",
            targets: ["Navigation"]
        )
    ],
    targets: [
        .target(
            name: "Architecture",
        ),
        .testTarget(
            name: "ArchitectureTests",
            dependencies: ["Architecture"],
            path: "Tests/Architecture"
        ),
        .target(
            name: "ModelConverter",
        ),
        .testTarget(
            name: "ModelConverterTests",
            dependencies: ["ModelConverter"],
            path: "Tests/ModelConverter"
        ),
        .target(
            name: "Navigation",
        ),
        .testTarget(
            name: "NavigationTests",
            dependencies: ["Navigation"],
            path: "Tests/Navigation"
        )
    ]
)
 
