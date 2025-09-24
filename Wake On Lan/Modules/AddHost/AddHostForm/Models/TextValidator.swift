//
//  TextValidator.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 17.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import Foundation

struct TextValidator: Validator {

    typealias Value = String
    typealias Pattern = String

    private var pattern: Pattern

    init<Strategy: RegExPatternRepresentable>(strategy: Strategy) {
        self.pattern = strategy.regExPattern
    }

    func validate(value: Value) -> Bool {
        value.matches(pattern)
    }
}
