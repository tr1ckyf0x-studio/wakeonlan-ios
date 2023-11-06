// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum AboutScreen {
    internal enum Item {
      /// Donate
      internal static let donate = L10n.tr("Localizable", "AboutScreen.Item.Donate", fallback: "Donate")
      /// GitHub
      internal static let github = L10n.tr("Localizable", "AboutScreen.Item.Github", fallback: "GitHub")
      /// Rate App
      internal static let rateApp = L10n.tr("Localizable", "AboutScreen.Item.RateApp", fallback: "Rate App")
      /// Share App
      internal static let shareApp = L10n.tr("Localizable", "AboutScreen.Item.ShareApp", fallback: "Share App")
      /// Version
      internal static let version = L10n.tr("Localizable", "AboutScreen.Item.Version", fallback: "Version")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = Bundle.resourcesBundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
