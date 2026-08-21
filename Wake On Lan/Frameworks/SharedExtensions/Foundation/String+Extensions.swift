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
        // NOTE: Every non-value character is dropped, not just `separator`, so that input pasted with
        // a foreign separator ("AA-BB-CC-DD-EE-FF", "AA.BB.CC.DD.EE.FF") is re-formatted by the mask
        // instead of being interleaved with it.
        let cleanString = components(separatedBy: separator)
            .joined()
            .filter { $0.isLetter || $0.isNumber }
        var result = Self.empty
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
