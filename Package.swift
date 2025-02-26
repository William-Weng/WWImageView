// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWImageView",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "WWImageView", targets: ["WWImageView"]),
    ],
    targets: [
        .target(name: "WWImageView", resources: [.copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
