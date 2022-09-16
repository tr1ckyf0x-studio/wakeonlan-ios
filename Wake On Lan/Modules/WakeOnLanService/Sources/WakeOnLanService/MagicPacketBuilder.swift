import Foundation

public final class MagicPacketBuilder {
    public init() { }
}

// MARK: - BuildsMagicPacket
extension MagicPacketBuilder: BuildsMagicPacket {
    public func build(for macAddress: String?) throws -> [UInt8] {
        guard let macAddress = macAddress else { throw MagicPacketError.wrongMacAddressFormat }

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
            throw MagicPacketError.wrongMacAddressFormat
        }

        let body = Array(
            repeating: macComponents,
            count: Constants.magicPacketBodyLength
        ).flatMap { $0 }

        let magicPacketBytes = header + body

        return magicPacketBytes
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
