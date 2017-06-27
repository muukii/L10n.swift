//
//  ReferenceDictionary.swift
//  L10n
//
//  Created by muukii on 4/5/17.
//
//

import Foundation

class ReferenceDictionary<Key: Hashable, Value>: CustomStringConvertible {

  var source: [Key : Value]

  init(source: [Key : Value] = [:]) {
    self.source = source
  }

  subscript (key: Key) -> Value? {
    get {
      return source[key]
    }
    set {
      guard let newValue = newValue else {
        source.removeValue(forKey: key)
        return
      }
      source[key] = newValue
    }
  }

  var description: String {
    return source.description
  }

  var jsonString: String {
    return description
      .replacingOccurrences(of: "[", with: "{")
      .replacingOccurrences(of: "]", with: "}")
      .replacingOccurrences(of: " ", with: "")
  }
}
