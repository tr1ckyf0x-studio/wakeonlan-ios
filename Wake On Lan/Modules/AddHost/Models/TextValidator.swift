//
//  TextValidator.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 17.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

class TextValidator: Validator {
    
    typealias Value = String
    typealias Pattern = String
    
    private var pattern: Pattern
    
    init<Strategy: RegExPatternRepresentable>(strategy: Strategy) {
        self.pattern = strategy.regExPattern
    }
    
    func validate(value: Value) -> Bool {
        return value.matches(pattern)
    }
}
