import Foundation

import JAYSON
import Guaka

let root = Command(usage: "main")

let gen = Command(
  usage: "gen",
  shortMessage: "Generate",
  longMessage: nil,
  flags: [
    Flag(shortName: "i", longName: "input", type: String.self, description: "input", required: true, inheritable: false),
    Flag(shortName: "o", longName: "output", type: String.self, description: "output", required: true, inheritable: false),
    Flag(shortName: "t", longName: "target", type: String.self, description: "target", required: true, inheritable: false),
    Flag(shortName: "p", longName: "prefix", type: String.self, description: "prefix", required: false, inheritable: false),
  ],
  example: "",
  parent: nil,
  aliases: [],
  deprecationStatus: .notDeprecated) { (flags, args) in

    // standardizingPath : ~/ => /Users/Foo/
    let input = (flags.get(name: "input", type: String.self)! as NSString).standardizingPath
    let output = (flags.get(name: "output", type: String.self)! as NSString).standardizingPath
    let target = flags.get(name: "target", type: String.self)!
    let prefix = flags.get(name: "prefix", type: String.self) ?? ""

    guard let data = FileManager.default.contents(atPath: input) else {
      fatalError("Not found file: \(input)")
    }

    do {

      let parser = Parser()
      let validator = Validator()
      let stringsGenerator = StringsGenerator(prefix: prefix)

      let strings = try validator.run(
        strings: try parser.run(jsonData: data)
      )

      let data = try stringsGenerator.run(strings: strings, target: target)

      let fileManager = FileManager.default

      let outputDirectoryURL = URL(fileURLWithPath: output)
        .appendingPathComponent(target)
        .appendingPathExtension("lproj")

      let outputFileURL = outputDirectoryURL.appendingPathComponent("Localizable.strings")


      try fileManager.createDirectory(at: outputDirectoryURL, withIntermediateDirectories: true, attributes: [:])
      try data.write(to: outputFileURL)
    } catch {
      print(error)
      exit(1)
    }
    
    print("Complete! \(target)")
    
}

let find = Command(
  usage: "find",
  shortMessage: "Generate",
  longMessage: nil,
  flags: [
    Flag(shortName: "p", longName: "path", type: String.self, description: "Root path", required: true, inheritable: false),
    ],
  example: "",
  parent: nil,
  aliases: [],
  deprecationStatus: .notDeprecated) { f, _ in

    let rootPath = f.get(name: "path", type: String.self)!
    print(FileManager.default.walk(rootPath: rootPath))
}


root.add(subCommand: gen)
root.add(subCommand: find)

root.execute()
