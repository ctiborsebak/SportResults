// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Feature",
    defaultLocalization: "en",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "Results",
            targets: ["Results"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", .upToNextMajor(from: "2.5.3")),
        .package(path: "../Domain"),
        .package(path: "../Generic"),
        .package(path: "../Localizations"),
        .package(path: "../Theme"),
    ],
    targets: [
        .target(
            name: "Results",
            dependencies: [
                .product(name: "Architecture", package: "Generic"),
                .product(name: "Domain", package: "Domain"),
                .product(name: "FactoryKit", package: "Factory"),
                .product(name: "Localizations", package: "Localizations"),
                .product(name: "ModalResult", package: "Generic"),
                .product(name: "ModelConverter", package: "Generic"),
                .product(name: "Navigation", package: "Generic"),
                .product(name: "Persistence", package: "Generic"),
                .product(name: "Theme", package: "Theme"),
            ]
        ),
        .testTarget(
            name: "ResultsTests",
            dependencies: ["Results"],
            path: "Tests/Results"
        ),
    ]
)
