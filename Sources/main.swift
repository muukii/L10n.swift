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
    Flag(shortName: "d", longName: "debug", type: Bool.self, description: "debug", required: false, inheritable: false),
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
    let debug = flags.get(name: "debug", type: Bool.self) ?? false

    print(debug)

    guard let data = FileManager.default.contents(atPath: input) else {
      fatalError("Not found file: \(input)")
    }

    do {

      let parser = Parser()
      let validator = Validator()
      let stringsGenerator = StringsGenerator(prefix: prefix, debug: debug)
      let codeGenerator = CodeGenerator()

      let strings = try validator.run(
        strings: try parser.run(jsonData: data)
      )

      let stringsData = try stringsGenerator.run(strings: strings, target: target)
      let codeData = try codeGenerator.run(strings: strings, target: target)

      let fileManager = FileManager.default

      let outputDirectoryURL = URL(fileURLWithPath: output)

      let stringsOutputDirURL = outputDirectoryURL
        .appendingPathComponent(target)
        .appendingPathExtension("lproj")

      let stringsOutputFileURL = stringsOutputDirURL
        .appendingPathComponent("Localizable.strings")

      let codeOutputFileURL = outputDirectoryURL
        .appendingPathComponent("Strings.swift")

      try fileManager.createDirectory(at: stringsOutputDirURL, withIntermediateDirectories: true, attributes: [:])

      try stringsData.write(to: stringsOutputFileURL)
      try codeData.write(to: codeOutputFileURL)
    } catch {
      fatalError("\(error)")
    }
    
    print("Complete! \(target)")
}

let ls = Command(
  usage: "ls",
  shortMessage: "Describe key, value",
  longMessage: nil,
  flags: [
    Flag(shortName: "i", longName: "input", type: String.self, description: "input", required: true, inheritable: false),
    ],
  example: "",
  parent: nil,
  aliases: [],
  deprecationStatus: .notDeprecated) { flags, a in

    let input = (flags.get(name: "input", type: String.self)! as NSString).standardizingPath
    guard let data = FileManager.default.contents(atPath: input) else {
      fatalError("Not found file: \(input)")
    }

    do {
      let parser = Parser()
      let result = try parser.run(jsonData: data)

      result.forEach { o in
        print(o.key)
      }

    } catch {
      fatalError("\(error)")
    }
}

let find = Command(
  usage: "find",
  shortMessage: "find",
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

let add = Command(
  usage: "add",
  shortMessage: "add L10n",
  longMessage: nil,
  flags: [
    Flag(shortName: "p", longName: "path", type: String.self, description: "json path", required: true, inheritable: false),
    ],
  example: "",
  parent: nil,
  aliases: [],
  deprecationStatus: .notDeprecated) { f, a in

    let rootPath = f.get(name: "path", type: String.self)!
    print(FileManager.default.walk(rootPath: rootPath))
}

root.add(subCommand: gen)
root.add(subCommand: ls)
root.add(subCommand: find)

root.execute()
