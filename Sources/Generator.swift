//
//  Gen.swift
//  L10n
//
//  Created by muukii on 2016/11/20.
//
//

import Foundation

import JAYSON

enum Generator {
  static func gen(json: JAYSON, target: String) throws -> String {
    guard case .dictionary = json.sourceType else {
      fatalError("Invalid json")
    }

    var flattenArray: [(String, [String : String])] = []

    func _flatten(keys: [String], json: JAYSON) throws {

      if case .dictionary = json.sourceType {

        try json.getDictionary().forEach { json in
          if json.key == "l10n" {

            let d = try json.value.getDictionary().reduce([String : String]()) { dic, t in
              var dic = dic
              if case .string = t.value.sourceType {
                dic[t.key] = try t.value.getString()
              }
              return dic
            }
            flattenArray.append((keys.joined(separator: "."), d))
          } else {
            try _flatten(keys: keys + [json.key], json: json.value)
          }
        }
      }
    }

    try _flatten(keys: [], json: json)

    print(flattenArray)
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
