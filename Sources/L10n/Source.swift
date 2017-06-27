//
//  Source.swift
//  L10n
//
//  Created by muukii on 6/27/17.
//

import Foundation

struct Source: Codable {
  
  typealias Language = String
  
  struct Configuration: Codable {
    let languages: [Language]
  }
  
  struct Strings: Codable {
    
    struct LocalizedString: Codable {
      
      let id: String
      let strings: [Language : String]
    }
    
    let stringSet: [String : LocalizedString]
    
    func sortedStringSet() -> [(key: String, value: Source.Strings.LocalizedString)] {
      
      return stringSet.sorted(by: { $0.key < $1.key })
    }
    
  }
  
  let configuration: Configuration
  let strings: Strings
  
}

extension Source {
  
  private enum CodingKeys: String, CodingKey {
    case configuration
    case strings
  }
}

extension Source.Strings {
  
  private struct Key: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
      self.stringValue = stringValue
    }
    
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
  }
  
  init(from decoder: Decoder) throws {
    
    let c = try decoder.container(keyedBy: Key.self)
    
    var _s: [String : LocalizedString] = [:]
    
    for key in c.allKeys {
      _s[key.stringValue] = try c.decode(LocalizedString.self, forKey: key)
    }
    
    self.stringSet = _s
  }
}

extension Source.Strings.LocalizedString {
  
  private struct Key: CodingKey {
    var stringValue: String
    init?(stringValue: String) {
      self.stringValue = stringValue
    }
    
    var intValue: Int? { return nil }
    init?(intValue: Int) { return nil }
    
    static let id = Key(stringValue: "id")!
  }
  
  init(from decoder: Decoder) throws {
    let c = try decoder.container(keyedBy: Key.self)
    self.id = try c.decode(String.self, forKey: .id)
    
    var _strings: [String : String] = [:]
    for key in c.allKeys where key.stringValue != Key.id.stringValue {
      _strings[key.stringValue] = try c.decode(String.self, forKey: key)
    }
    self.strings = _strings
  }
}
