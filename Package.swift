// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "WebimWidget",
    defaultLocalization: "en",
    products: [
        .library(
            name: "WebimWidget",
            targets: ["WebimWidget"]),
    ],
    dependencies: [
        .package(url: "https://github.com/webim/webim-client-sdk-ios.git", 
exact: "3.39.0"),
        .package(url: "https://github.com/kean/Nuke.git", from: "8.0.0"),
        .package(url: "https://github.com/evgenyneu/Cosmos.git", from: "20.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.0")


    ],
    targets: [
        .target(
            name: "WebimWidget",
            dependencies: [
                .product(name: "WebimClientLibrary", package: "webim-client-sdk-ios"),
                .product(name: "Nuke", package: "Nuke"),
                .product(name: "Cosmos", package: "Cosmos"),
                .product(name: "SnapKit", package: "SnapKit")
            ],
            path: "Sources/WebimWidget")
    ]
)
