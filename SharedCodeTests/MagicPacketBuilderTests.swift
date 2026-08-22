//
//  MagicPacketBuilderTests.swift
//  SharedCodeTests
//
//  Created by Vladislav Lisianskii on 22. 8. 2026..
//

import Foundation
import Testing

@testable import WakeOnLanService

/// The builder is `public` and documents a `throws MagicPacketError.wrongMacAddressFormat` contract,
/// so what it refuses is part of its API.
@Suite("Magic packet")
struct MagicPacketBuilderTests {
    private let builder = MagicPacketBuilder()

    @Test("A valid address produces six 0xFF bytes followed by sixteen copies of the address")
    func buildsWellFormedPacket() throws {
        let packet = try builder.build(for: "01:23:45:67:89:AB")

        #expect(packet.count == 6 + 16 * 6)
        #expect(packet.prefix(6).allSatisfy { $0 == 0xFF })

        let address: [UInt8] = [0x01, 0x23, 0x45, 0x67, 0x89, 0xAB]
        for repetition in 0..<16 {
            let start = 6 + repetition * 6
            #expect(Array(packet[start..<(start + 6)]) == address)
        }
    }

    @Test("Lowercase hex is accepted")
    func acceptsLowercase() throws {
        #expect(try builder.build(for: "ab:cd:ef:01:23:45") == builder.build(for: "AB:CD:EF:01:23:45"))
    }

    // The regression this suite exists for: the length check used to run over the *parsed* groups, so
    // any address with six parseable groups among however many was accepted and woke whichever
    // machine those six happened to name.
    @Test(
        "Addresses that are not exactly six hex pairs are refused",
        arguments: [
            "AA:BB:CC:DD:EE:FF:GG",     // a seventh group that does not parse
            "AA:BB:CC:DD:EE:FF:",       // trailing separator
            "::AA:BB:CC:DD:EE:FF",      // leading separators
            "AA:BB:CC:DD:EE",           // one group short
            "A:B:C:D:E:F",              // single digits, which the AddHost form rejects
            "+A:BB:CC:DD:EE:FF",        // UInt8(_:radix:) accepts a leading sign on its own
            "１２:BB:CC:DD:EE:FF",       // full-width digits satisfy isHexDigit but not UInt8
            "AA-BB-CC-DD-EE-FF",        // the wrong separator
            "GG:HH:II:JJ:KK:LL",        // nothing hexadecimal at all
            ""
        ]
    )
    func refusesMalformedAddresses(_ macAddress: String) {
        #expect(throws: MagicPacketError.wrongMacAddressFormat) {
            try builder.build(for: macAddress)
        }
    }

    @Test("A missing address is refused rather than treated as empty")
    func refusesNil() {
        #expect(throws: MagicPacketError.wrongMacAddressFormat) {
            try builder.build(for: nil)
        }
    }
}
