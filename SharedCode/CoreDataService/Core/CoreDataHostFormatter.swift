//
//  HostCoreDataFormatter.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 29.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import Foundation

enum CoreDataHostFormatter {

    enum DataType {
        case macAddress
        case ipAddress

        fileprivate var separator: String {
            switch self {
            case .macAddress:
                return ":"

            case .ipAddress:
                return "."
            }
        }

        fileprivate var radix: Int {
            switch self {
            case .macAddress:
                return 16

            case .ipAddress:
                return 10
            }
        }

        fileprivate var stringFormat: String {
            switch self {
            case .macAddress:
                return "%02X"

            case .ipAddress:
                return "%U"
            }
        }
    }

    static func compress(string: String, ofType dataType: DataType) -> Data {
        let bytes = string
            .components(separatedBy: dataType.separator)
            .compactMap { UInt8($0, radix: dataType.radix) }
        return Data(bytes)
    }

    static func decompress(data: Data, ofType dataType: DataType) -> String {
        data
            .map { String(format: dataType.stringFormat, $0) }
            .joined(separator: dataType.separator)
    }
}
