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
            name: "GPSEntities",
            targets: ["GPSEntities"]
        ),
        .library(
            name: "Database",
            targets: ["Database"]
        ),
        .library(
            name: "Visualizations",
            targets: ["Visualizations"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/mysql-kit.git", from: "4.0.0"),
        .package(url: "https://github.com/eneko/SwiftDotEnv", branch: "main"),
        .package(url: "https://github.com/groue/GRDB.swift.git", from: "5.23.0"),
        .package(url: "https://github.com/eneko/GzipSwift.git", branch: "develop"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/eneko/Stripes", from: "0.2.0"),
    ],
    targets: [
        .executableTarget(
            name: "GrandPrixStatsCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Gzip", package: "GzipSwift"),
                "Database",
                "Rasterizer",
                "Visualizations"
            ]
        ),
        .target(
            name: "Database",
            dependencies: [
                .product(name: "MySQLKit", package: "mysql-kit"),
                .product(name: "GRDB", package: "GRDB.swift"),
                "SwiftDotEnv"
            ]
        ),
        .target(
            name: "GPSModel",
            dependencies: [
                "Database",
                "GPSEntities"
            ]
        ),
        .target(
            name: "GPSEntities",
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
                "GPSEntities",
                "GPSModel"
            ]
        ),
        .testTarget(
            name: "ParsingTests",
            dependencies: [
                .product(name: "Gzip", package: "GzipSwift")
            ]
        ),
    ]
)
