//
//  Parser.swift
//  l10n
//
//  Created by muukii on 3/7/17.
//
//

import Foundation

final class Parser {

  enum Error: Swift.Error {
    case invalidJSON
  }

  init() {

  }

  func run(jsonData: Data) throws -> Source {
    
    let decoder = JSONDecoder()
    
    let source = try decoder.decode(Source.self, from: jsonData)
        
    return source
  }
}
