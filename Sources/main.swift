import Foundation

import JAYSON
import Guaka

let i = Flag(shortName: "i", longName: "input", type: String.self, description: "input", required: true, inheritable: false)
let o = Flag(shortName: "o", longName: "output", type: String.self, description: "output", required: true, inheritable: false)
let t = Flag(shortName: "t", longName: "target", type: String.self, description: "target", required: true, inheritable: false)
let p = Flag(shortName: "p", longName: "prefix", type: String.self, description: "prefix", required: false, inheritable: false)

let command = Command(
  usage: "gen",
  shortMessage: "Generate",
  longMessage: nil,
  flags: [i, o, t, p],
  example: "",
  parent: nil,
  aliases: [],
  deprecationStatus: .notDeprecated) { (flags, args) in

    let input = flags.get(name: "input", type: String.self)!
    let output = flags.get(name: "output", type: String.self)!
    let target = flags.get(name: "target", type: String.self)!
    let prefix = flags.get(name: "prefix", type: String.self) ?? ""

    guard let data = FileManager.default.contents(atPath: input) else {
      fatalError("Not found file: \(input)")
    }

    do {

      let json = try JAYSON.init(data: data)

      let result = try Generator.gen(json: json, target: target, prefix: prefix)

      let fileManager = FileManager.default

      let outputDirectoryURL = URL(fileURLWithPath: output)
        .appendingPathComponent(target)

      let outputFileURL = outputDirectoryURL.appendingPathComponent("Localizable.strings")


      try fileManager.createDirectory(at: outputDirectoryURL, withIntermediateDirectories: true, attributes: [:])
      let data = result.data(using: .utf8)
      try data?.write(to: outputFileURL)
    } catch {
      print(error)
      exit(1)
    }
    
    print("Complete! \(target)")
    
}

command.execute()


//import Commander
//
//let commandGroup = Group {
//
//  $0.command(
//    "gen",
//    Argument<String>("input", description: "input yaml file path"),
//    Argument<String>("output", description: "output directory"),
//    Argument<String>("target", description: "target language [Base, ja, zh_Hant]"),
//    { input, output, target in
//
//  })
//}
//
//commandGroup.run()
