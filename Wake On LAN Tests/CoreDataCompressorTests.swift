//
//  HostCoreDataFormatterTests.swift
//  WakeOnLanTests
//
//  Created by Владислав Лисянский on 29.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import XCTest
@testable import Wake_on_LAN

class HostCoreDataFormatterTests: XCTestCase {

    func testMACAddressCompress() throws {
        let macAddressString = "11:22:33:FF:AA:BB"
        let macAddressData = HostCoreDataFormatter.compress(string: macAddressString, ofDataType: .macAddress)
        let controlData = Data([0x11, 0x22, 0x33, 0xFF, 0xAA, 0xBB])
        XCTAssertEqual(macAddressData, controlData)
    }

    func testMACAddressDecompress() throws {
        let macAddressData = Data([0x11, 0x22, 0x33, 0xFF, 0xAA, 0xBB])
        let macAddressString = HostCoreDataFormatter.decompress(data: macAddressData, ofDataType: .macAddress)
        let controlString = "11:22:33:FF:AA:BB"
        XCTAssertEqual(macAddressString, controlString)
    }

    func testIPAddressCompress() throws {
        let macAddressString = "192.168.1.1"
        let macAddressData = HostCoreDataFormatter.compress(string: macAddressString, ofDataType: .ipAddress)
        let controlData = Data([192, 168, 1, 1])
        XCTAssertEqual(macAddressData, controlData)
    }

    func testIPAddressDecompress() throws {
        let macAddressData = Data([192, 168, 1, 1])
        let macAddressString = HostCoreDataFormatter.decompress(data: macAddressData, ofDataType: .ipAddress)
        let controlString = "192.168.1.1"
        XCTAssertEqual(macAddressString, controlString)
    }

}
