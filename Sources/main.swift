import Foundation

import JAYSON
import Commander

let commandGroup = Group {

  $0.command(
    "gen",
    Argument<String>("input", description: "input yaml file path"),
    Argument<String>("output", description: "output directory"),
    Argument<String>("target", description: "target language [Base, ja, zh_Hant]"),
    { input, output, target in

      guard let data = FileManager.default.contents(atPath: input) else {
        fatalError("Not found file: \(input)")
      }

      let json = try JAYSON.init(data: data)

      let result = try Generator.gen(json: json, target: target)

      let fileManager = FileManager.default

      let outputDirectoryURL = URL(fileURLWithPath: output)
        .appendingPathComponent(target)

      let outputFileURL = outputDirectoryURL.appendingPathComponent("Localizable.strings")

      do {
        try fileManager.createDirectory(at: outputDirectoryURL, withIntermediateDirectories: true, attributes: [:])
        let data = result.data(using: .utf8)
        try data?.write(to: outputFileURL)
      } catch {
        print(error)
        exit(1)
      }

      print("Complete! \(target)")
  })
}

commandGroup.run()
