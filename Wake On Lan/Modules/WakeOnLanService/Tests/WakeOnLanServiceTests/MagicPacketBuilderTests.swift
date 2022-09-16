import XCTest

@testable import WakeOnLanService

final class MagicPacketBuilderTests: XCTestCase {

    private var magicPacketBuilder: MagicPacketBuilder!

    override func setUp() {
        super.setUp()
        magicPacketBuilder = MagicPacketBuilder()
    }

    func testBuild() throws {
        // when
        let magicPacket = try magicPacketBuilder.build(for: TestData.testableMacAddress)
        // then
        XCTAssertEqual(
            magicPacket,
            TestData.expectedMagicPacket
        )
    }

    func testBuildWithInvalidMACAddress() throws {
        XCTAssertThrowsError(
            try magicPacketBuilder.build(for: TestData.invalidMacAddress),
            "magicPacketBuilder must throw error if MAC address is invalid"
        )
    }

    func testBuildWithNilMACAddress() throws {
        XCTAssertThrowsError(
            try magicPacketBuilder.build(for: nil),
            "magicPacketBuilder must throw error if MAC address is nil"
        )
    }
}

// MARK: - TestData
extension MagicPacketBuilderTests {
    private enum TestData {
        static let testableMacAddress = "01:02:03:AB:CD:EF"
        static let expectedMagicPacket: [UInt8] = [
            0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
            0x01, 0x02, 0x03, 0xAB, 0xCD, 0xEF,
            0x01, 0x02, 0x03, 0xAB, 0xCD, 0xEF,
            0x01, 0x02, 0x03, 0xAB, 0xCD, 0xEF,
            0x01, 0x02, 0x03, 0xAB, 0xCD, 0xEF,
            0x01, 0x02, 0x03, 0xAB, 0xCD, 0xEF,
            0x01, 0x02, 0x03, 0xAB, 0xCD, 0xEF,
            0x01, 0x02, 0x03, 0xAB, 0xCD, 0xEF,
            0x01, 0x02, 0x03, 0xAB, 0xCD, 0xEF,
            0x01, 0x02, 0x03, 0xAB, 0xCD, 0xEF,
            0x01, 0x02, 0x03, 0xAB, 0xCD, 0xEF,
            0x01, 0x02, 0x03, 0xAB, 0xCD, 0xEF,
            0x01, 0x02, 0x03, 0xAB, 0xCD, 0xEF,
            0x01, 0x02, 0x03, 0xAB, 0xCD, 0xEF,
            0x01, 0x02, 0x03, 0xAB, 0xCD, 0xEF,
            0x01, 0x02, 0x03, 0xAB, 0xCD, 0xEF,
            0x01, 0x02, 0x03, 0xAB, 0xCD, 0xEF
        ]

        static let invalidMacAddress = "123"
    }
}
