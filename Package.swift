// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TrueSDK",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "TrueSDK",
            targets: ["TrueSDK"]
        )
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [],
            path: "TrueSDK/Core",
            publicHeadersPath: "Include",
            cSettings: [
                .define("SPM_SDK")
            ]
        ),
        .target(
            name: "TrueSDK",
            dependencies: ["Core"],
            path: "TrueSDK/External",
            resources: [
                .process("Assets.xcassets")
            ],
            publicHeadersPath: "",
            cSettings: [
                .define("SPM_SDK")
            ]
        )
    ]
)

