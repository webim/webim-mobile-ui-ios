// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "WebimMobileWidget",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "WebimMobileWidget",
            targets: ["WebimMobileWidget"]),
    ],
    dependencies: [
        .package(url: "https://github.com/webim/webim-client-sdk-ios.git", exact: "4.0.0"),
        .package(url: "https://github.com/webim/webim-mobile-keyboard-ios.git", exact: "1.0.4"),
        .package(url: "https://github.com/kean/Nuke.git", from: "12.0.0"),
        .package(url: "https://github.com/evgenyneu/Cosmos.git", from: "25.0.1"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1"),
        .package(url: "https://github.com/Flipboard/FLAnimatedImage.git", from: "1.0.17"),
        .package(url: "https://github.com/SVGKit/SVGKit.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "WebimMobileWidget",
            dependencies: [
                .byName(name: "WebimMobileSDK"),
                .byName(name: "WebimKeyboard"),
                .product(name: "Nuke", package: "Nuke"),
                .product(name: "Cosmos", package: "Cosmos"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "FLAnimatedImage", package: "FLAnimatedImage"),
                .product(name: "SVGKit", package: "SVGKit")
            ],
            path: "Sources",
            resources: [.copy("WebimMobileWidget/PrivacyInfo.xcprivacy")]
        )
    ]
)
