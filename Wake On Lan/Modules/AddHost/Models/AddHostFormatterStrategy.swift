//
//  AddHostFormatterStrategy.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 25.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

enum AddHostFormatterStrategy {
    case macAddress
    case ipAddress
    case port
}

// MARK: - FormatPatternRepresentable
extension AddHostFormatterStrategy: FormatPatternRepresentable {
    var formatPattern: String {
        return "XX:XX:XX:XX:XX:XX"
    }

    var separator: String {
        switch self {
        case .macAddress:
            return ":"
        default:
            return String()
        }
    }

}
