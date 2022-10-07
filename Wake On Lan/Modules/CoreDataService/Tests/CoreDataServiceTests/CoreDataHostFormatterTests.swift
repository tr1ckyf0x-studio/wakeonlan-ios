//
//  CoreDataHostFormatterTests.swift
//  CoreDataServiceTests
//
//  Created by Владислав Лисянский on 29.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

@testable import CoreDataService
import XCTest

class HostCoreDataFormatterTests: XCTestCase {

    func testMACAddressCompress() throws {
        let macAddressString = "11:22:33:FF:AA:BB"
        let macAddressData = CoreDataHostFormatter.compress(string: macAddressString, ofType: .macAddress)
        let controlData = Data([0x11, 0x22, 0x33, 0xFF, 0xAA, 0xBB])
        XCTAssertEqual(macAddressData, controlData)
    }

    func testMACAddressDecompress() throws {
        let macAddressData = Data([0x11, 0x22, 0x33, 0xFF, 0xAA, 0xBB])
        let macAddressString = CoreDataHostFormatter.decompress(data: macAddressData, ofType: .macAddress)
        let controlString = "11:22:33:FF:AA:BB"
        XCTAssertEqual(macAddressString, controlString)
    }

    func testIPAddressCompress() throws {
        let macAddressString = "192.168.1.1"
        let macAddressData = CoreDataHostFormatter.compress(string: macAddressString, ofType: .ipAddress)
        let controlData = Data([192, 168, 1, 1])
        XCTAssertEqual(macAddressData, controlData)
    }

    func testIPAddressDecompress() throws {
        let macAddressData = Data([192, 168, 1, 1])
        let macAddressString = CoreDataHostFormatter.decompress(data: macAddressData, ofType: .ipAddress)
        let controlString = "192.168.1.1"
        XCTAssertEqual(macAddressString, controlString)
    }

}
