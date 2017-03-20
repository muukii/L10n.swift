//
//  CodeGenerator.swift
//  l10n
//
//  Created by muukii on 3/7/17.
//
//

import Foundation

final class CodeGenerator {

  init() {

  }

  func run(strings: [String : [String : String]], target: String) throws -> Data {

    var lines: [String] = []

    lines.append("enum L10n {")
    strings.forEach { key, value in
      lines.append("  /// \(value["Base"]!)")
      lines.append("  case \(key.camelCased())")
    }
    lines.append("}")
    lines.append("extension L10n: CustomStringConvertible {")
    lines.append("  var description: String { return self.string }")
    lines.append("  var string: String {")
    lines.append("    switch self {")
    strings.forEach { key, value in
      lines.append("    case .\(key.camelCased()):")
      lines.append("      return L10n.tr(key: \"\(key)\")")
    }
    lines.append("    }")
    lines.append("  }")
    lines.append("")
    lines +=
      [
        "  private static func tr(key: String, _ args: CVarArg...) -> String {",
        "    let format = AppLocalizedString(key, comment: \"\", bundle: Bundle(for: BundleClass.self))",
        "    return String(format: format, locale: Locale.current, arguments: args)",
        "  }",
    ]
    
    lines.append("}")
    
    let result = lines.joined(separator: "\n")
    print(result)
    return result.data(using: .utf8)!
  }
}
