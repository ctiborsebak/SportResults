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
    targets: [
        .target(
          name: "Theme",
          path: "Sources"
        )
      ]
)
