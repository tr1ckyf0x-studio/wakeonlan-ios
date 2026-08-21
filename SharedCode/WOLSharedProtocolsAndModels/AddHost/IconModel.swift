//
//  IconModel.swift
//  WOLUIComponents
//
//  Created by Dmitry on 13.12.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import SFSafeSymbols

public protocol IconModelRepresentable {
    var symbol: SFSymbol { get }
}

public struct IconModel: IconModelRepresentable {
    public let symbol: SFSymbol

    public init(symbol: SFSymbol) {
        self.symbol = symbol
    }
}

// MARK: - Equatable

extension IconModel: Equatable {
    public static func == (lhs: IconModel, rhs: IconModel) -> Bool {
        lhs.symbol == rhs.symbol
    }
}
