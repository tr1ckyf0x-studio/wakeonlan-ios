//
//  AddHostValidationStrategy.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

enum AddHostValidationStrategy {
    case title
    case macAddress
    case ipAddress
    case port
}

// MARK: - RegExPatternRepresentable

extension AddHostValidationStrategy: RegExPatternRepresentable {
    var regExPattern: String {
        switch self {
        case .title:
            return "(.|\\s)*\\S(.|\\s)*"
        case .macAddress:
            return "^([0-9a-fA-F][0-9a-fA-F]:){5}([0-9a-fA-F][0-9a-fA-F])$"
        case .ipAddress:
            return "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
        case .port:
            return "^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$"
        }
    }

}
