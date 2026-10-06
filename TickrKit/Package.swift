// swift-tools-version: 6.2

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
    targets: [
        .target(name: "Domain", path: "Sources/Core/Domain"),
        .target(name: "Networking", path: "Sources/Core/Networking"),
        .target(name: "PriceFeed", dependencies: ["Domain", "Networking"], path: "Sources/Core/PriceFeed"),
        .target(name: "DesignSystem", dependencies: ["Domain"]),
        .target(name: "SymbolDetailFeature", dependencies: ["Domain", "DesignSystem"], path: "Sources/Features/SymbolDetail"),
        .target(name: "SymbolListFeature", dependencies: ["Domain", "DesignSystem", "PriceFeed", "SymbolDetailFeature"], path: "Sources/Features/SymbolList"),

        .testTarget(name: "DomainTests", dependencies: ["Domain"], path: "Tests/Core/DomainTests"),
        .testTarget(name: "PriceFeedTests", dependencies: ["PriceFeed", "Domain", "Networking"], path: "Tests/Core/PriceFeedTests"),
        .testTarget(name: "SymbolListFeatureTests", dependencies: ["SymbolListFeature", "PriceFeed", "Domain"], path: "Tests/Features/SymbolListTests"),
    ]
)
