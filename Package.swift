// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GrandPrixStats",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "gps",
            targets: ["GrandPrixStatsCLI"]
        ),
        .library(
            name: "Visualizations",
            targets: ["Visualizations"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .executableTarget(
            name: "GrandPrixStatsCLI",
            dependencies: [
                "Rasterizer",
                "Visualizations"
            ]
        ),
        .target(
            name: "GrandPrixStats",
            dependencies: []
        ),
        .target(
            name: "Rasterizer",
            dependencies: []
        ),
        .target(
            name: "Visualizations",
            dependencies: []
        ),
        .testTarget(
            name: "GrandPrixStatsTests",
            dependencies: ["GrandPrixStats"]
        ),
    ]
)
