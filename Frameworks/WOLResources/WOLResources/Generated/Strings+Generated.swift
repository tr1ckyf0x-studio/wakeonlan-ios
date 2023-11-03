// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum AboutScreen {
    /// Donate
    public static let donate = L10n.tr("AboutScreen", "Donate", fallback: "Donate")
    /// GitHub
    public static let github = L10n.tr("AboutScreen", "github", fallback: "GitHub")
    /// Rate App
    public static let rateApp = L10n.tr("AboutScreen", "rate app", fallback: "Rate App")
    /// Share App
    public static let shareApp = L10n.tr("AboutScreen", "share app", fallback: "Share App")
    /// Version
    public static let version = L10n.tr("AboutScreen", "version", fallback: "Version")
  }
  public enum AddHost {
    /// Add host
    public static let addHost = L10n.tr("AddHost", "add host", fallback: "Add host")
    /// Cancel
    public static let cancel = L10n.tr("AddHost", "cancel", fallback: "Cancel")
    /// Tap to change icon
    public static let changeIcon = L10n.tr("AddHost", "change icon", fallback: "Tap to change icon")
    /// Choose Icon
    public static let chooseIcon = L10n.tr("AddHost", "choose icon", fallback: "Choose Icon")
    /// Host
    public static let host = L10n.tr("AddHost", "host", fallback: "Host")
    /// IP address or domain name of the target computer. Instead, you may use the broadcast IP of your sub-network, for example 192.168.0.255, 192.168.1.255, or 10.0.0.255. If field is not specified, 255.255.255.255 will be used
    public static let hostAddressDescription = L10n.tr("AddHost", "host address description", fallback: "IP address or domain name of the target computer. Instead, you may use the broadcast IP of your sub-network, for example 192.168.0.255, 192.168.1.255, or 10.0.0.255. If field is not specified, 255.255.255.255 will be used")
    /// MAC Address
    public static let macAddress = L10n.tr("AddHost", "mac address", fallback: "MAC Address")
    /// MAC address of the target computer. It can be found in the Ethernet network settings of the computer.
    public static let macAddressDescription = L10n.tr("AddHost", "mac address description", fallback: "MAC address of the target computer. It can be found in the Ethernet network settings of the computer.")
    /// Optional
    public static let `optional` = L10n.tr("AddHost", "optional", fallback: "Optional")
    /// Port
    public static let port = L10n.tr("AddHost", "port", fallback: "Port")
    /// The port magic packet will be sent to. 9 is usually supported by Ethernet cards. You may also try 7 or 0.
    public static let portDescription = L10n.tr("AddHost", "port description", fallback: "The port magic packet will be sent to. 9 is usually supported by Ethernet cards. You may also try 7 or 0.")
    /// Title
    public static let title = L10n.tr("AddHost", "title", fallback: "Title")
    /// Name that will be displayed in the host list
    public static let titleDescription = L10n.tr("AddHost", "title description", fallback: "Name that will be displayed in the host list")
    public enum AddHost {
      public enum Placeholder {
        /// 255.255.255.255
        public static let ipAddress = L10n.tr("AddHost", "AddHost.Placeholder.IpAddress", fallback: "255.255.255.255")
        /// XX:XX:XX:XX:XX:XX
        public static let macAddress = L10n.tr("AddHost", "AddHost.Placeholder.MacAddress", fallback: "XX:XX:XX:XX:XX:XX")
        /// 9
        public static let port = L10n.tr("AddHost", "AddHost.Placeholder.Port", fallback: "9")
        /// e.g. MacBook or NAS
        public static let title = L10n.tr("AddHost", "AddHost.Placeholder.Title", fallback: "e.g. MacBook or NAS")
      }
    }
  }
  public enum AddHostFailure {
    /// Incorrect MAC address
    public static let invalidMACAddress = L10n.tr("AddHostFailure", "invalidMACAddress", fallback: "Incorrect MAC address")
    /// Incorrect PORT
    public static let invalidPort = L10n.tr("AddHostFailure", "invalidPort", fallback: "Incorrect PORT")
    /// Incorrect Title
    public static let invalidTitle = L10n.tr("AddHostFailure", "invalidTitle", fallback: "Incorrect Title")
    /// Unknown Error
    public static let unknown = L10n.tr("AddHostFailure", "unknown", fallback: "Unknown Error")
  }
  public enum HostList {
    /// You must be connected to network
    public static let checkConnection = L10n.tr("HostList", "checkConnection", fallback: "You must be connected to network")
    /// Hosts
    public static let hosts = L10n.tr("HostList", "hosts", fallback: "Hosts")
    /// Packet sent
    public static let packetSent = L10n.tr("HostList", "packetSent", fallback: "Packet sent")
  }
  public enum WakeOnLan {
    /// Tap to change icon
    public static let changeIcon = L10n.tr("WakeOnLan", "change icon", fallback: "Tap to change icon")
    /// There is nothing here.
    /// Press the plus button in the top right corner.
    public static let emptyViewMessage = L10n.tr("WakeOnLan", "empty view message", fallback: "There is nothing here.\nPress the plus button in the top right corner.")
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
