//
//  TextFormatter.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 25.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

struct TextFormatter: Formatter {
    private var format: String
    private var separator: String

    init<Strategy: FormatPatternRepresentable>(strategy: Strategy) {
        self.format = strategy.formatPattern
        self.separator = strategy.separator
    }

    func format(text: String) -> String {
        text.formatted(by: format, separator)
    }
}
