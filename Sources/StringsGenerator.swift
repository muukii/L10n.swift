//
//  StringsGenerator.swift
//  l10n
//
//  Created by muukii on 3/7/17.
//
//

import Foundation

final class StringsGenerator {

  enum Error: Swift.Error {
    case failedStringToData
  }

  let prefix: String
  let debug: Bool

  init(prefix: String, debug: Bool) {
    self.prefix = prefix
    self.debug = debug
  }

  func run(strings: [String : [String : String]], target: String) throws -> Data {

    let str = strings.map { dic -> String in
      guard let a = dic.value[target] else {
        fatalError("missing localized string")
      }

      let key = prefix + dic.0

      var value: String
      if debug {

        if a.isEmpty {
          value = key
        } else {
          value = a.replacingOccurrences(of: "\n", with: "\\n")
        }

      } else {
        value = a.replacingOccurrences(of: "\n", with: "\\n")
      }


      return "\"\(key)\" = \"\(value)\";"
      }
      .joined(separator: "\n")

    guard let data = str.data(using: .utf8) else {
      throw Error.failedStringToData
    }
    return data
  }
}
