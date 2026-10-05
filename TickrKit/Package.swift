// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TickrKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "PriceFeed", targets: ["PriceFeed"]),
        .library(name: "SymbolListFeature", targets: ["SymbolListFeature"]),
        .library(name: "SymbolDetailFeature", targets: ["SymbolDetailFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/daltoniam/Starscream.git", from: "4.0.0")
    ],
    targets: [
        .target(name: "Domain"),
        .target(name: "Networking", dependencies: [.product(name: "Starscream", package: "Starscream")]),
        .target(name: "PriceFeed", dependencies: ["Domain", "Networking"]),
        .target(name: "DesignSystem", dependencies: ["Domain"]),
        .target(name: "SymbolListFeature", dependencies: ["Domain", "DesignSystem"]),
        .target(name: "SymbolDetailFeature", dependencies: ["Domain", "DesignSystem"]),
        
        .testTarget(name: "DomainTests", dependencies: ["Domain"]),
        .testTarget(name: "NetworkingTests", dependencies: ["Networking"]),
        .testTarget(name: "PriceFeedTests", dependencies: ["PriceFeed"]),
        .testTarget(name: "SymbolListFeatureTests", dependencies: ["SymbolListFeature"]),
    ]
)
