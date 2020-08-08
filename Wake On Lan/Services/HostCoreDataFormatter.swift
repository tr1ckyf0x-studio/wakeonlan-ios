//
//  HostCoreDataFormatter.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 29.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

final class HostCoreDataFormatter {
    
    private init() { }
    
    enum DataType {
        case macAddress
        case ipAddress
        
        var separator: String {
            switch self {
            case .macAddress:
                return ":"
                
            case .ipAddress:
                return "."
            }
        }
        
        var radix: Int {
            switch self {
            case .macAddress:
                return 16
                
            case .ipAddress:
                return 10
            }
        }
        
        var stringFormat: String {
            switch self {
            case .macAddress:
                return "%X"
                
            case .ipAddress:
                return "%U"
            }
        }
    }
    
    class func compress(string: String, ofType dataType: DataType) -> Data {
        let bytes = string
            .components(separatedBy: dataType.separator)
            .compactMap { UInt8($0, radix: dataType.radix) }
        return Data(bytes)
    }
    
    class func decompress(data: Data, ofType dataType: DataType) -> String {
        return data
            .map { String(format: dataType.stringFormat, $0) }
            .joined(separator: dataType.separator)
    }
}
