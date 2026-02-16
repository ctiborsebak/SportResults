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
            name: "ModalResult",
            targets: ["ModalResult"]
        ),
        .library(
            name: "Navigation",
            targets: ["Navigation"]
        ),
        .library(
            name: "Persistence",
            targets: ["Persistence"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", .upToNextMajor(from: "2.5.3")),
        .package(path: "../Domain"),
        .package(path: "../Localizations"),
        .package(path: "../Theme")
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
            name: "ModalResult",
            dependencies: [
                "Architecture",
                "Navigation",
                .product(name: "Localizations", package: "Localizations"),
                .product(name: "Theme", package: "Theme")
            ]
        ),
        .testTarget(
            name: "ModalResultTests",
            dependencies: ["ModalResult"],
            path: "Tests/ModalResult"
        ),
        .target(
            name: "Navigation",
            dependencies: [
                .product(name: "FactoryKit", package: "Factory"),
                .product(name: "Theme", package: "Theme")
            ]
        ),
        .testTarget(
            name: "NavigationTests",
            dependencies: ["Navigation"],
            path: "Tests/Navigation"
        ),
        .target(
            name: "Persistence",
            dependencies: [
                "ModelConverter",
                .product(name: "Domain", package: "Domain"),
                .product(name: "FactoryKit", package: "Factory")
            ]
        ),
        .testTarget(
            name: "PersistenceTests",
            dependencies: ["Persistence"],
            path: "Tests/Persistence"
        ),
    ]
)

