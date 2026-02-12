// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Feature",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "Results",
            targets: ["Results"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", .upToNextMajor(from: "2.5.3")),
        .package(path: "../Generic")
    ],
    targets: [
        .target(
            name: "Results",
            dependencies: [
                .product(name: "Architecture", package: "Generic"),
                .product(name: "FactoryKit", package: "Factory"),
            ]
        ),
        .testTarget(
            name: "ResultsTests",
            dependencies: ["Results"],
            path: "Tests/Results"
        ),
    ]
)
