//
//  String+RegEx.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

extension String {
    func matches(_ regex: String) -> Bool {
        self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    func formatted(by mask: String, _ separator: String) -> String {
        let cleanString = self.components(separatedBy: separator).joined()
        var result = ""
        var index = cleanString.startIndex
        for char in mask where index < cleanString.endIndex {
            if char == "X" {
                result.append(cleanString[index])
                index = cleanString.index(after: index)
            } else {
                result.append(char)
            }
        }

        return result
    }
}
