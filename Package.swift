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
                .define("SPM_SDK"),
                .headerSearchPath("Categories"),
                .headerSearchPath("Network/Models"),
                .headerSearchPath("Network/Requests"),
                .headerSearchPath("Views")
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
                .define("SPM_SDK"),
                .headerSearchPath("../Core/Network/Models"),
                .headerSearchPath("../Core/Network/Requests"),
                .headerSearchPath("../Core/Categories"),
                .headerSearchPath("../Core/Views")
                
            ]
        )
    ]
)

