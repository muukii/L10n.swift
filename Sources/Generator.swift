//
//  Gen.swift
//  L10n
//
//  Created by muukii on 2016/11/20.
//
//

import Foundation

import JAYSON

public enum Generator {
  public static func gen(json: JAYSON, target: String, prefix: String) throws -> String {
    guard case .dictionary = json.sourceType else {
      fatalError("Invalid json")
    }

    var flattenArray: [(String, [String : String])] = []

    func _flatten(keys: [String], json: JAYSON) throws {
      try json.getDictionary().forEach { dictionary in
        if dictionary.key == "l10n" {

          let d = try dictionary.value.getDictionary().reduce([String : String]()) { dic, t in
            var dic = dic
            dic[t.key] = try t.value.getString()
            return dic
          }

          let key = ([prefix] + keys).joined(separator: ".")
          flattenArray.append((key, d))
          print("key", key, "value", d)
        } else {
          try _flatten(keys: keys + [dictionary.key], json: dictionary.value)
        }
      }
    }

    try _flatten(keys: [], json: json)

    print(flattenArray.count)

    return flattenArray.map { dic -> String in
      guard let a = dic.1[target] else {
        fatalError("missing localized string")
      }
      return "\"\(dic.0)\" = \"\(a.replacingOccurrences(of: "\n", with: "\\n"))\";"
      }
      .joined(separator: "\n")
  }
}
