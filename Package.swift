// swift-tools-version: 6.3

import PackageDescription

let package = Package(
  name: "EnvironmentLogger",
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
