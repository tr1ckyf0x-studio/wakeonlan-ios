import Foundation

enum MagicPacketBuilder {
    /**
     Builds magic packet for specified macAddress.
     
     - Parameter macAddress: MAC address the magic packet building for.
                             Must consist of 6 bytes in hex format, separated by colons.
     - Throws: `MagicPacketBuilder.Error.wrongMacAddressFormat` if `macAddress` has wrong format.
     - Returns: Byte array of the magic packet

     - Note: Magic packet consists of header - 6 times repeated 0xFF
     and body - 16 times repeated MAC address
     in the following order:

     `[header][body]`
     */
    static func build(for macAddress: String?) throws -> [UInt8] {
        guard let macAddress = macAddress else { throw Self.Error.wrongMacAddressFormat }

        let header = Array(
            repeating: Constants.magicPacketHeaderByte,
            count: Constants.magicPacketHeaderLength
        )
        let macComponents = macAddress
            .components(separatedBy: Constants.macAddressDigitSeparator)
            .compactMap { digit -> UInt8? in
                UInt8(digit, radix: Constants.macAddressRadix)
            }

        guard macComponents.count == Constants.macAddressBytesCount else {
            throw Self.Error.wrongMacAddressFormat
        }

        let body = Array(
            repeating: macComponents,
            count: Constants.magicPacketBodyLength
        ).flatMap { $0 }

        let magicPacketBytes = header + body

        return magicPacketBytes
    }
}

// MARK: - Error
extension MagicPacketBuilder {
    enum Error: LocalizedError {
        case wrongMacAddressFormat

        var errorDescription: String? {
            switch self {
            case .wrongMacAddressFormat:
                return "MAC address must consist of 6 bytes in hex format, separated by colons."
            }
        }
    }
}

// MARK: - Constants
extension MagicPacketBuilder {
    private enum Constants {
        static let magicPacketHeaderLength = 6
        static let magicPacketHeaderByte: UInt8 = 0xFF
        static let magicPacketBodyLength = 16
        static let macAddressDigitSeparator = ":"
        static let macAddressRadix = 16
        static let macAddressBytesCount = 6
    }
}
