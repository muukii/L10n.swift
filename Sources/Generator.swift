//
//  Gen.swift
//  L10n
//
//  Created by muukii on 2016/11/20.
//
//

import Foundation

import Yams

enum Generator {
  static func gen(node: Node, target: String) -> String {
    guard case .mapping = node else {
      fatalError("Invalid yaml")
    }

    var flattenArray: [(String, [String : String])] = []

    func _flatten(keys: [String], node: Node) {

      if case .mapping(let m) = node {

        m.forEach { m in
          if m.0 == "l10n" {
            guard case .mapping(let _m) = m.1 else {
              fatalError("Something went wrong")
            }

            let d = _m.reduce([String : String]()) { dic, t in
              var dic = dic
              if case .scalar(let v) = t.1 {
                dic[t.0] = v
              }
              return dic
            }

            flattenArray.append((keys.joined(separator: "."), d))
          } else {
            _flatten(keys: keys + [m.0], node: m.1)
          }
        }
      }
    }

    _flatten(keys: [], node: node)

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
