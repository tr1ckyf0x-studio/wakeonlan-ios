//
//  AddHostValidationStrategy.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

enum AddHostValidationStrategy: RegExPatternRepresentable {
    case macAddress
    case ipAddress
    case port
    
    var regExPattern: String {
        switch self {
        case .macAddress: return "^([0-9a-fA-F][0-9a-fA-F]:){5}([0-9a-fA-F][0-9a-fA-F])$"
        case .ipAddress: return "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
        case .port: return "^[0-9]+$"
        }
    }
}
