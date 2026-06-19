// swift-tools-version: 6.1

import PackageDescription

let package = Package(
  name: "EnvironmentLogger",
  platforms: [
    .iOS(.v14),
    .macOS(.v11),
    .tvOS(.v14),
    .watchOS(.v7),
    .visionOS(.v1),
  ],
  products: [
    .library(
      name: "EnvironmentLogger",
      targets: ["EnvironmentLogger"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/swiftlang/swift-docc-plugin.git", from: "1.5.0")
  ],
  targets: [
    .target(
      name: "EnvironmentLogger"
    ),
    .testTarget(
      name: "EnvironmentLoggerTests",
      dependencies: ["EnvironmentLogger"]
    ),
  ],
  swiftLanguageModes: [.v6]
)
