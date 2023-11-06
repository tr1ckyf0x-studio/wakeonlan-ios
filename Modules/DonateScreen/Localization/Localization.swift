// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum DonateScreen {
    internal enum Screen {
      /// Donations do not unlock any extra features in the application. The application is provided free of charge and any donations are your gratitude for our work.
      internal static let footer = L10n.tr("DonateScreen", "DonateScreen.Screen.Footer", fallback: "Donations do not unlock any extra features in the application. The application is provided free of charge and any donations are your gratitude for our work.")
      /// In-App purchases are unavailable on your device.
      internal static let paymentsUnavailable = L10n.tr("DonateScreen", "DonateScreen.Screen.PaymentsUnavailable", fallback: "In-App purchases are unavailable on your device.")
      /// Donate
      internal static let title = L10n.tr("DonateScreen", "DonateScreen.Screen.Title", fallback: "Donate")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
