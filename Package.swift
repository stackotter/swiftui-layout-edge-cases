// swift-tools-version: 5.7

import PackageDescription
import Foundation

let swiftSettings: [SwiftSetting]
let dependencies: [Target.Dependency]
if ProcessInfo.processInfo.environment["USE_SCUI"] == "1" {
    swiftSettings = [
        .define("USE_SCUI")
    ]
    dependencies = [
        .product(name: "SwiftCrossUI", package: "swift-cross-ui"),
        .product(name: "DefaultBackend", package: "swift-cross-ui")
    ]
} else {
    swiftSettings = []
    dependencies = []
}

let package = Package(
    name: "SwiftUILayoutEdgeCases",
    platforms: [.macOS(.v13), .iOS(.v14), .tvOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/stackotter/swift-cross-ui", revision: "7406f229eb639a2a8f068d7a8eaa27fc7dab11fd"),
    ],
    targets: [
        .executableTarget(
            name: "SwiftUILayoutEdgeCases",
            dependencies: dependencies,
            swiftSettings: swiftSettings
        )
    ]
)
