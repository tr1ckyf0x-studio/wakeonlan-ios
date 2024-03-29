//
//  String+Extensions.swift
//  SharedExtensions
//
//  Created by Dmitry on 19.12.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

public extension String {

    static let empty: String = .init()

    func matches(_ regex: String) -> Bool {
        range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }

    func formatted(by mask: String, _ separator: String) -> String {
        let cleanString = components(separatedBy: separator).joined()
        var result = String.empty
        var index = cleanString.startIndex
        for char in mask where index < cleanString.endIndex {
            if char == Configuration.maskSymbol {
                result.append(cleanString[index])
                index = cleanString.index(after: index)
            } else {
                result.append(char)
            }
        }

        return result
    }

    private enum Configuration {
        static let maskSymbol: Character = "X"
    }
}
