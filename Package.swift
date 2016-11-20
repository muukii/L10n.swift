import PackageDescription

let package = Package(
  name: "L10n",
  dependencies: [
    .Package(url: "https://github.com/jpsim/Yams.git", majorVersion: 0),
    .Package(url: "git@github.com:kylef/Commander.git", majorVersion: 0),
  ]
)
