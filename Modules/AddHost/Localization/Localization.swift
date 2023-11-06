// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum AddHost {
    internal enum Form {
      internal enum ActionSheet {
        /// Cancel
        internal static let cancel = L10n.tr("Localizable", "AddHost.Form.ActionSheet.Cancel", fallback: "Cancel")
        /// Choose Icon
        internal static let chooseIcon = L10n.tr("Localizable", "AddHost.Form.ActionSheet.ChooseIcon", fallback: "Choose Icon")
      }
      internal enum Failure {
        /// Unknown Error
        internal static let unknown = L10n.tr("Localizable", "AddHost.Form.Failure.unknown", fallback: "Unknown Error")
      }
      internal enum Field {
        internal enum ChangeIcon {
          /// Tap to change icon
          internal static let title = L10n.tr("Localizable", "AddHost.Form.Field.ChangeIcon.Title", fallback: "Tap to change icon")
        }
        internal enum Host {
          /// IP address or domain name of the target computer. Instead, you may use the broadcast IP of your sub-network, for example 192.168.0.255, 192.168.1.255, or 10.0.0.255. If field is not specified, 255.255.255.255 will be used.
          internal static let description = L10n.tr("Localizable", "AddHost.Form.Field.Host.Description", fallback: "IP address or domain name of the target computer. Instead, you may use the broadcast IP of your sub-network, for example 192.168.0.255, 192.168.1.255, or 10.0.0.255. If field is not specified, 255.255.255.255 will be used.")
          /// 255.255.255.255
          internal static let placeholder = L10n.tr("Localizable", "AddHost.Form.Field.Host.Placeholder", fallback: "255.255.255.255")
          /// Host
          internal static let title = L10n.tr("Localizable", "AddHost.Form.Field.Host.Title", fallback: "Host")
        }
        internal enum MacAddress {
          /// MAC address of the target computer. It can be found in the Ethernet network settings of the computer.
          internal static let description = L10n.tr("Localizable", "AddHost.Form.Field.MacAddress.Description", fallback: "MAC address of the target computer. It can be found in the Ethernet network settings of the computer.")
          /// XX:XX:XX:XX:XX:XX
          internal static let placeholder = L10n.tr("Localizable", "AddHost.Form.Field.MacAddress.Placeholder", fallback: "XX:XX:XX:XX:XX:XX")
          /// MAC Address
          internal static let title = L10n.tr("Localizable", "AddHost.Form.Field.MacAddress.Title", fallback: "MAC Address")
          internal enum Failure {
            /// Incorrect MAC address
            internal static let invalidMACAddress = L10n.tr("Localizable", "AddHost.Form.Field.MacAddress.Failure.InvalidMACAddress", fallback: "Incorrect MAC address")
          }
        }
        internal enum Name {
          /// Name that will be displayed in the host list.
          internal static let description = L10n.tr("Localizable", "AddHost.Form.Field.Name.Description", fallback: "Name that will be displayed in the host list.")
          /// e.g. MacBook or NAS
          internal static let placeholder = L10n.tr("Localizable", "AddHost.Form.Field.Name.Placeholder", fallback: "e.g. MacBook or NAS")
          /// Name
          internal static let title = L10n.tr("Localizable", "AddHost.Form.Field.Name.Title", fallback: "Name")
        }
        internal enum Port {
          /// The port magic packet will be sent to. 9 is usually supported by Ethernet cards. You may also try 7 or 0.
          internal static let description = L10n.tr("Localizable", "AddHost.Form.Field.Port.Description", fallback: "The port magic packet will be sent to. 9 is usually supported by Ethernet cards. You may also try 7 or 0.")
          /// 9
          internal static let placeholder = L10n.tr("Localizable", "AddHost.Form.Field.Port.Placeholder", fallback: "9")
          /// Port
          internal static let title = L10n.tr("Localizable", "AddHost.Form.Field.Port.Title", fallback: "Port")
          internal enum Failure {
            /// Incorrect port
            internal static let invalidPort = L10n.tr("Localizable", "AddHost.Form.Field.Port.Failure.InvalidPort", fallback: "Incorrect port")
          }
        }
      }
      internal enum Misc {
        /// Optional
        internal static let `optional` = L10n.tr("Localizable", "AddHost.Form.Misc.Optional", fallback: "Optional")
      }
    }
    internal enum Screen {
      /// Add host
      internal static let title = L10n.tr("Localizable", "AddHost.Screen.Title", fallback: "Add host")
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
