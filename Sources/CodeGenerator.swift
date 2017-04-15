//
//  CodeGenerator.swift
//  l10n
//
//  Created by muukii on 3/7/17.
//
//

import Foundation
import Guitar

#if os(macOS)
  typealias RegularExpression = NSRegularExpression
#endif

final class CodeGenerator {

  init() {

  }

  func run(strings: [String : [String : String]], target: String) throws -> Data {

    var l: [String] = []

    l.append("import Foundation")
    l.append("import AppFoundation")    
    l.append("")
    l.append("enum L10n {")
    strings.forEach { key, value in

      let value = value["Base"]!

      l.append("  /// \(value)")
      l.append("  case \(key.camelCased())\(genCase(source: value))")
    }
    l.append("}")
    l.append("extension L10n: CustomStringConvertible {")
    l.append("  var description: String { return self.string }")
    l.append("  var string: String {")
    l.append("    switch self {")
    strings.forEach { key, value in
      let value = value["Base"]!
      l.append("    case .\(key.camelCased())\(genSwitch(source: value)):")
      l.append("      return L10n.tr(key: \"\(key)\")")
      l.append(genAsTemplate(source: value))
    }
    l.append("    }")
    l.append("  }")
    l.append("")
    l +=
      [
        "  private static func tr(key: String, _ args: CVarArg...) -> String {",
        "    let format = AppLocalizedString(key, comment: \"\", bundle: Bundle(for: BundleClass.self))",
        "    return String(format: format, locale: Locale.current, arguments: args)",
        "  }",
    ]

    l.append("}")

    l += [
      "extension String {",
      "  public init(template: String, args: [String : CustomStringConvertible]) {",
      "    var text = template",
      "    for arg in args {",
      "      let format = \"{{ \\(arg.key) }}\"",
//      "      assert(text.range(of: format) != nil, \"Not found key : \\(arg.key)\")",
      "      text = text.replacingOccurrences(of: format, with: arg.value.description)",
      "    }",
      "    self = text",
      "  }",
      "  public func asTemplate(args: [String : CustomStringConvertible]) -> String {",
      "    return String(template: self, args: args)",
      "  }",
      "}",
      ]

    l.append("private class BundleClass {}")
    l.append("")
    
    let result = l.joined(separator: "\n")
    print(result)
    return result.data(using: .utf8)!
  }

  func injectNames(source: String) -> [String] {

    let regex = try! RegularExpression(pattern: "\\{\\{\\s*(.+?)\\s*\\}\\}", options: [])
    let r = regex.matches(in: source, options: [], range: NSRange(location: 0, length: source.characters.count))
    let s = r.map { a in
      (source as NSString).substring(with: a.rangeAt(1))
    }

    return s.map { $0.camelCased() }
  }

  func genCase(source: String) -> String {

    let names = injectNames(source: source)

    guard names.isEmpty == false else {
      return ""
    }

    let format = names.map {
      "\($0): String"
    }
    .joined(separator: ", ")

    return "(\(format))"
  }

  func genSwitch(source: String) -> String {

    let names = injectNames(source: source)

    guard names.isEmpty == false else {
      return ""
    }

    let format = names.map {
      "let \($0)"
      }
      .joined(separator: ", ")

    return "(\(format))"
  }

  func genAsTemplate(source: String) -> String {

    let s = injectNames(source: source).map {
      "                \"\($0)\" : \($0)"
    }

    guard s.isEmpty == false else {
      return ""
    }

    var body: [String] = []
    body.append("              .asTemplate(args: [")
    body += s
    body.append("              ])")

    return body.joined(separator: "\n")
  }
}
