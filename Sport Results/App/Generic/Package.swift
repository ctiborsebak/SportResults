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
    ]
)
 
