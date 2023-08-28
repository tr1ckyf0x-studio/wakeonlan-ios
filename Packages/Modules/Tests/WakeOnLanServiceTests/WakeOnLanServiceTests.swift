import XCTest

import SharedProtocolsAndModels
@testable import WakeOnLanService
import WakeOnLanServiceMock

final class WakeOnLanServiceTests: XCTestCase {

    var wakeOnLanService: WakeOnLanService!
    var magicPacketBuilderMock: BuildsMagicPacketMock!
    var udpServiceMock: UDPServiceProtocolMock!

    override func setUp() {
        super.setUp()
        magicPacketBuilderMock = BuildsMagicPacketMock()
        udpServiceMock = UDPServiceProtocolMock()
        wakeOnLanService = WakeOnLanService(
            magicPacketBuilder: magicPacketBuilderMock,
            udpService: udpServiceMock
        )
    }

    func testSendMagicPacket() throws {
        // given
        magicPacketBuilderMock.buildForReturnValue = TestData.testablePacket
        // when
        try wakeOnLanService.sendMagicPacket(to: TestData.Correct.host)
        // then
        XCTAssertEqual(
            magicPacketBuilderMock.buildForReceivedMacAddress,
            TestData.Correct.host.macAddress,
            "WakeOnLanService must pass macAddress to magicPacketBuilder"
        )
        XCTAssertEqual(
            udpServiceMock.sendToPortReceivedArguments?.packet,
            TestData.testablePacket,
            "WakeOnLanService must use packet received from magicPacketBuilder"
        )
        XCTAssertEqual(
            udpServiceMock.sendToPortReceivedArguments?.port,
            TestData.Correct.expectedPort,
            "WakeOnLanService must use port from passed host"
        )
        XCTAssertEqual(
            udpServiceMock.sendToPortReceivedArguments?.ipAddress,
            TestData.Correct.host.ipAddress,
            "WakeOnLanService must use destination from passed host"
        )
    }

    func testSendMagicPacketWithoutIPAddressAndPort() throws {
        // given
        magicPacketBuilderMock.buildForReturnValue = TestData.testablePacket
        // when
        try wakeOnLanService.sendMagicPacket(to: TestData.EmptyIPAddressAndPort.host)
        // then
        XCTAssertEqual(
            udpServiceMock.sendToPortReceivedArguments?.ipAddress,
            TestData.EmptyIPAddressAndPort.expectedIPAddress,
            "WakeOnLanService must use default broadcast IP address"
        )
        XCTAssertEqual(
            udpServiceMock.sendToPortReceivedArguments?.port,
            TestData.EmptyIPAddressAndPort.expectedPort,
            "WakeOnLanService must use default port"
        )
    }

}

// MARK: - TestData
// swiftlint:disable nesting
extension WakeOnLanServiceTests {
    private enum TestData {
        static let testablePacket: [UInt8] = [0x00, 0x11]

        enum Correct {
            static let host = HostStub(
                macAddress: "01:02:03:AB:CD:EF",
                ipAddress: "255.255.255.255",
                port: "1"
            )

            static let expectedPort: UInt16 = 1
        }

        enum EmptyIPAddressAndPort {
            static let host = HostStub(
                macAddress: "01:02:03:AB:CD:EF",
                ipAddress: nil,
                port: nil
            )

            static let expectedIPAddress = "255.255.255.255"

            static let expectedPort: UInt16 = 9
        }
    }
}
// swiftlint:enable nesting
