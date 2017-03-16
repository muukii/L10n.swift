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

  init(prefix: String) {
    self.prefix = prefix
  }

  func run(strings: [String : [String : String]], target: String) throws -> Data {

    let str = strings.map { dic -> String in
      guard let a = dic.value[target] else {
        fatalError("missing localized string")
      }


      let key = prefix + dic.0

      return "\"\(key)\" = \"\(a.replacingOccurrences(of: "\n", with: "\\n"))\";"
      }
      .joined(separator: "\n")

    guard let data = str.data(using: .utf8) else {
      throw Error.failedStringToData
    }
    return data
  }
}
