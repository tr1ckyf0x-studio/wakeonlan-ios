// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Add host
  internal static let addHost = L10n.tr("Localizable", "add host", fallback: "Add host")
  /// Cancel
  internal static let cancel = L10n.tr("Localizable", "cancel", fallback: "Cancel")
  /// Tap to change icon
  internal static let changeIcon = L10n.tr("Localizable", "change icon", fallback: "Tap to change icon")
  /// Choose Icon
  internal static let chooseIcon = L10n.tr("Localizable", "choose icon", fallback: "Choose Icon")
  /// Host
  internal static let host = L10n.tr("Localizable", "host", fallback: "Host")
  /// IP address or domain name of the target computer. Instead, you may use the broadcast IP of your sub-network, for example 192.168.0.255, 192.168.1.255, or 10.0.0.255. If field is not specified, 255.255.255.255 will be used
  internal static let hostAddressDescription = L10n.tr("Localizable", "host address description", fallback: "IP address or domain name of the target computer. Instead, you may use the broadcast IP of your sub-network, for example 192.168.0.255, 192.168.1.255, or 10.0.0.255. If field is not specified, 255.255.255.255 will be used")
  /// MAC Address
  internal static let macAddress = L10n.tr("Localizable", "mac address", fallback: "MAC Address")
  /// MAC address of the target computer. It can be found in the Ethernet network settings of the computer.
  internal static let macAddressDescription = L10n.tr("Localizable", "mac address description", fallback: "MAC address of the target computer. It can be found in the Ethernet network settings of the computer.")
  /// Optional
  internal static let `optional` = L10n.tr("Localizable", "optional", fallback: "Optional")
  /// Port
  internal static let port = L10n.tr("Localizable", "port", fallback: "Port")
  /// The port magic packet will be sent to. 9 is usually supported by Ethernet cards. You may also try 7 or 0.
  internal static let portDescription = L10n.tr("Localizable", "port description", fallback: "The port magic packet will be sent to. 9 is usually supported by Ethernet cards. You may also try 7 or 0.")
  /// Title
  internal static let title = L10n.tr("Localizable", "title", fallback: "Title")
  /// Name that will be displayed in the host list
  internal static let titleDescription = L10n.tr("Localizable", "title description", fallback: "Name that will be displayed in the host list")
  internal enum AddHost {
    internal enum Failure {
      /// Incorrect MAC address
      internal static let invalidMACAddress = L10n.tr("Localizable", "AddHost.Failure.invalidMACAddress", fallback: "Incorrect MAC address")
      /// Incorrect PORT
      internal static let invalidPort = L10n.tr("Localizable", "AddHost.Failure.invalidPort", fallback: "Incorrect PORT")
      /// Incorrect Title
      internal static let invalidTitle = L10n.tr("Localizable", "AddHost.Failure.invalidTitle", fallback: "Incorrect Title")
      /// Unknown Error
      internal static let unknown = L10n.tr("Localizable", "AddHost.Failure.unknown", fallback: "Unknown Error")
    }
    internal enum Placeholder {
      /// 255.255.255.255
      internal static let ipAddress = L10n.tr("Localizable", "AddHost.Placeholder.IpAddress", fallback: "255.255.255.255")
      /// XX:XX:XX:XX:XX:XX
      internal static let macAddress = L10n.tr("Localizable", "AddHost.Placeholder.MacAddress", fallback: "XX:XX:XX:XX:XX:XX")
      /// 9
      internal static let port = L10n.tr("Localizable", "AddHost.Placeholder.Port", fallback: "9")
      /// e.g. MacBook or NAS
      internal static let title = L10n.tr("Localizable", "AddHost.Placeholder.Title", fallback: "e.g. MacBook or NAS")
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
