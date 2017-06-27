// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "L10n",
  products: [
    .executable(name: "l10n", targets: ["L10n"]),
  ],
  dependencies: [
    .package(url: "https://github.com/kylef/PathKit.git", from: "0.8.0"),
    .package(url: "https://github.com/kylef/Commander.git", from: "0.6.0"),
    .package(url: "https://github.com/ArtSabintsev/Guitar.git", from: "0.0.12"),
  ],
  targets: [    
    .target(name: "L10n", dependencies: ["Guitar", "Commander"]),
  ],
  swiftLanguageVersions: [4]
)
