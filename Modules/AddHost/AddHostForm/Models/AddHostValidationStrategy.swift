//
//  AddHostValidationStrategy.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 17.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import Foundation

enum AddHostValidationStrategy {
    case title
    case macAddress
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
        case .port:
            return "^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$"
        }
    }
}
