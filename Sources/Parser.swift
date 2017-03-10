//
//  Parser.swift
//  l10n
//
//  Created by muukii on 3/7/17.
//
//

import Foundation
import JAYSON

final class Parser {

  init() {

  }

  func run(jsonData: Data) throws -> [String : [String : String]] {

    let json = try JSON(data: jsonData)

    var flattenArray: [String : [String : String]] = [:]

    func _flatten(keys: [String], json: JSON) throws {
      try json.getDictionary().forEach { dictionary in
        if dictionary.key == "l10n" {

          let d = try dictionary.value.getDictionary().reduce([String : String]()) { dic, t in
            var dic = dic
            dic[t.key] = try t.value.getString()
            return dic
          }

          let key = keys.joined(separator: ".")
          precondition(flattenArray[key] == nil, "\(key) is used twice.")
          flattenArray[key] = d
          print("key", key, "value", d)
        } else {
          try _flatten(keys: keys + [dictionary.key], json: dictionary.value)
        }
      }
    }

    try _flatten(keys: [], json: json)

    return flattenArray
  }
}
