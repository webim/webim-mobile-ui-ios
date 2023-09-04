// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "WebimMobileWidget",
    defaultLocalization: "en",
    products: [
        .library(
            name: "WebimMobileWidget",
            targets: ["WebimMobileWidget"]),
    ],
    dependencies: [
        .package(url: "https://github.com/webim/webim-client-sdk-ios.git", exact: "3.40.0"),
        .package(url: "https://github.com/kean/Nuke.git", from: "8.0.0"),
        .package(url: "https://github.com/evgenyneu/Cosmos.git", from: "20.0.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.0"),
        .package(url: "https://github.com/Flipboard/FLAnimatedImage.git", from: "1.0.17"),
        .package(url: "https://github.com/webim/webim-mobile-keyboard-ios.git", exact: "1.0.2")
    ],
    targets: [
        .target(
            name: "WebimMobileWidget",
            dependencies: [
                .product(name: "WebimMobileSDK", package: "webim-client-sdk-ios"),
                .product(name: "Nuke", package: "Nuke"),
                .product(name: "Cosmos", package: "Cosmos"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "FLAnimatedImage", package: "FLAnimatedImage"),
                .product(name: "WebimKeyboard", package: "webim-mobile-keyboard-ios")
            ],
            path: "Sources")
    ]
)
