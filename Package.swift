import PackageDescription

let package = Package(
  name: "L10n",
  dependencies: [
    .Package(url: "https://github.com/muukii/JAYSON.git", majorVersion: 1),
    .Package(url: "https://github.com/kylef/PathKit.git", majorVersion: 0, minor: 8),
    .Package(url: "https://github.com/oarrabi/Guaka", majorVersion: 0),
    .Package(url: "https://github.com/oarrabi/Regex", majorVersion: 0),
    .Package(url: "https://github.com/kylef/Stencil.git", majorVersion: 0),
  ]
)
