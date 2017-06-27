//
//  StringsGenerator.swift
//  l10n
//
//  Created by muukii on 3/7/17.
//
//

import Foundation

final class StringsGenerator {
  
  struct Result {
    
    var dataSet: [Source.Language : Data] = [:]
  }

  enum Error: Swift.Error {
    case failedStringToData
  }

  let prefix: String
  let debug: Bool

  init(prefix: String, debug: Bool) {
    self.prefix = prefix
    self.debug = debug
  }

  func run(source: Source) throws -> Result {
    
    let set = source.strings.sortedStringSet()
    
    var r = Result()
    
    for language in source.configuration.languages {
      
      let data = set.map { v -> String in
        
        let key = prefix + v.key
        let _value = v.value.strings[language]!
        
        let value: String
        if debug, _value.isEmpty {
          
          value = key
          
        } else {
          
          value = _value.replacingOccurrences(of: "\n", with: "\\n")
        }
        
        return "\"\(key)\" = \"\(value)\";"
        }
        .joined(separator: "\n")
        .data(using: .utf8)
      
      r.dataSet[language] = data
    }
    
    return r
  }
}
