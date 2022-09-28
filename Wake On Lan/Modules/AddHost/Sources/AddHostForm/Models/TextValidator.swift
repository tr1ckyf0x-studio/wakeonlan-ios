//
//  TextValidator.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

struct TextValidator {

    typealias Value = String
    typealias Pattern = String

    private var pattern: Pattern

    init<Strategy: RegExPatternRepresentable>(strategy: Strategy) {
        self.pattern = strategy.regExPattern
    }
}

// MARK: - Validator
extension TextValidator: Validator {
    func isValid(value: Value) -> Bool {
        value.matches(pattern)
    }
}
