//
//  main.swift
//  L10n
//
//  Created by muukii on 6/27/17.
//

import Foundation
import Commander

Group { g in
  g.command(
  "gen",
  Argument<String>("input", description: "input source file"),
  Argument<String>("output", description: "output"),
  Option<String>("prefix", ""),
  Flag("debug")
  ) { input, output, prefix, debug in
    
    print(input, output, prefix, debug)
    
    let input = input.standardizingPath
    let output = output.standardizingPath
    
    guard let data = FileManager.default.contents(atPath: input) else {
      fatalError("Not found file: \(input)")
    }
    
    let parser = Parser()
    let validator = Validator()
    let stringsGenerator = StringsGenerator(prefix: prefix, debug: debug)
    let codeGenerator = CodeGenerator()
    
    do {
    
      let source = try parser.run(jsonData: data)
      let stringsResult = try stringsGenerator.run(source: source)
      let codeResult = try codeGenerator.run(source: source)
      
      let outputDirectoryURL = URL(fileURLWithPath: output)
      
      let fileManager = FileManager.default
      
      for (language, data) in stringsResult.dataSet {
        
        let stringsOutputDirURL = outputDirectoryURL
          .appendingPathComponent(language)
          .appendingPathExtension("lproj")
        
        try fileManager.createDirectory(at: stringsOutputDirURL, withIntermediateDirectories: true, attributes: [:])
        
        try data.write(to: stringsOutputDirURL.appendingPathComponent("Localizable.strings"))
      }
      
      let codeOutputFileURL = outputDirectoryURL
        .appendingPathComponent("Strings.swift")
      
      try codeResult.write(to: codeOutputFileURL)
      
    } catch {
      
      fatalError("\(error)")
    }
    
  }
}.run()
