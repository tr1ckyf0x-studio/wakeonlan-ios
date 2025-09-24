import Foundation

public enum MagicPacketError {
    case wrongMacAddressFormat
}

// MARK: - LocalizedError

extension MagicPacketError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .wrongMacAddressFormat:
            return "MAC address must consist of 6 bytes in hex format, separated by colons."
        }
    }
}
