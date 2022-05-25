// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GrandPrixStats",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "gps",
            targets: ["GrandPrixStatsCLI"]
        ),
        .library(
            name: "GPSModels",
            targets: ["GPSModels"]
        ),
        .library(
            name: "Visualizations",
            targets: ["Visualizations"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/mysql-kit.git", from: "4.0.0"),
        .package(url: "https://github.com/eneko/SwiftDotEnv", branch: "main"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/eneko/Stripes", from: "0.2.0"),
    ],
    targets: [
        .executableTarget(
            name: "GrandPrixStatsCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Database",
                "Rasterizer",
                "Visualizations"
            ]
        ),
        .target(
            name: "Database",
            dependencies: [
                .product(name: "MySQLKit", package: "mysql-kit"),
                "GPSModels",
                "SwiftDotEnv"
            ]
        ),
        .target(
            name: "GPSModels",
            dependencies: []
        ),
        .target(
            name: "Rasterizer",
            dependencies: []
        ),
        .target(
            name: "Visualizations",
            dependencies: [
                .product(name: "Stripes", package: "Stripes"),
                "GPSModels"
            ]
        ),
    ]
)
