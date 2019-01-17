// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum Localizations {

  internal enum General {
    /// All
    internal static let all = Localizations.tr("Localizable", "general.all")
    /// Categories
    internal static let categories = Localizations.tr("Localizable", "general.categories")
    /// Facts - %@
    internal static func facts(_ p1: String) -> String {
      return Localizations.tr("Localizable", "general.facts", p1)
    }
    /// Favorites
    internal static let favorites = Localizations.tr("Localizable", "general.favorites")
    /// New
    internal static let new = Localizations.tr("Localizable", "general.new")
    /// Ok
    internal static let ok = Localizations.tr("Localizable", "general.ok")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension Localizations {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
