// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum HostList {
    internal enum NavigationBar {
      /// Donate
      internal static let donate = L10n.tr("Localizable", "HostList.NavigationBar.Donate", fallback: "Donate")
    }
    internal enum Notification {
      /// You must be connected to network
      internal static let checkConnection = L10n.tr("Localizable", "HostList.Notification.CheckConnection", fallback: "You must be connected to network")
      /// Packet sent
      internal static let packetSent = L10n.tr("Localizable", "HostList.Notification.PacketSent", fallback: "Packet sent")
    }
    internal enum Screen {
      /// There is nothing here.
      /// Press the plus button in the top right corner.
      internal static let emptyViewMessage = L10n.tr("Localizable", "HostList.Screen.EmptyViewMessage", fallback: "There is nothing here.\nPress the plus button in the top right corner.")
      /// Hosts
      internal static let title = L10n.tr("Localizable", "HostList.Screen.Title", fallback: "Hosts")
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
