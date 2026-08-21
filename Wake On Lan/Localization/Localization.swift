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
  internal enum DonateScreen {
    internal enum Screen {
      /// Donations do not unlock any extra features in the application. The application is provided as is and any donations are your gratitude for our work.
      internal static let footer = L10n.tr("Localizable", "DonateScreen.Screen.Footer", fallback: "Donations do not unlock any extra features in the application. The application is provided as is and any donations are your gratitude for our work.")
      /// Could not load donations. Check your connection and open this screen again.
      internal static let loadingFailed = L10n.tr("Localizable", "DonateScreen.Screen.LoadingFailed", fallback: "Could not load donations. Check your connection and open this screen again.")
      /// In-App purchases are unavailable on your device.
      internal static let paymentsUnavailable = L10n.tr("Localizable", "DonateScreen.Screen.PaymentsUnavailable", fallback: "In-App purchases are unavailable on your device.")
      /// Donate
      internal static let title = L10n.tr("Localizable", "DonateScreen.Screen.Title", fallback: "Donate")
    }
  }
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
