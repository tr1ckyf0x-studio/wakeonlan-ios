import Foundation

public final class MagicPacketBuilder {
    public init() { }
}

// MARK: - BuildsMagicPacket

extension MagicPacketBuilder: BuildsMagicPacket {
    public func build(for macAddress: String?) throws -> [UInt8] {
        guard let macAddress else { throw MagicPacketError.wrongMacAddressFormat }

        let header = Array(
            repeating: Constants.magicPacketHeaderByte,
            count: Constants.magicPacketHeaderLength
        )
        // NOTE: count the groups before parsing any of them. Parsing first and counting the
        // survivors — which `compactMap` invites — accepts anything with six *parseable* groups
        // among however many: "AA:BB:CC:DD:EE:FF:GG" and "::AA:BB:CC:DD:EE:FF" both used to build a
        // well-formed packet aimed at a machine the caller never named.
        let groups = macAddress.components(separatedBy: Constants.macAddressDigitSeparator)

        guard groups.count == Constants.macAddressBytesCount else {
            throw MagicPacketError.wrongMacAddressFormat
        }

        var macComponents = [UInt8]()
        macComponents.reserveCapacity(groups.count)

        for group in groups {
            // All three conditions earn their place. `UInt8(_:radix:)` alone accepts a leading sign,
            // so "+A" parses as 10; a length check alone lets that through too; and `isHexDigit` is
            // true for full-width forms like "１２", which `UInt8` then rejects. Together they admit
            // exactly what the AddHost form does, keeping one definition of a valid MAC in the
            // codebase rather than two that can drift.
            guard
                group.count == Constants.macAddressDigitsPerByte,
                group.allSatisfy(\.isHexDigit),
                let byte = UInt8(group, radix: Constants.macAddressRadix)
            else {
                throw MagicPacketError.wrongMacAddressFormat
            }
            macComponents.append(byte)
        }

        let body = Array(
            repeating: macComponents,
            count: Constants.magicPacketBodyLength
        ).flatMap(\.self)

        return header + body
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
        static let macAddressDigitsPerByte = 2
    }
}
