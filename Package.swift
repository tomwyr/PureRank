// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PureRank",
  products: [
    .library(
      name: "PureRank",
      targets: ["PureRank"]
    )
  ],
  targets: [
    .target(
      name: "PureRank"
    ),
    .testTarget(
      name: "PureRankTests",
      dependencies: ["PureRank"]
    ),
  ]
)
