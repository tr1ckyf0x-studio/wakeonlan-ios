//
//  SFSymbol.swift
//  
//
//  Created by Vladislav Lisianskii on 31.07.2021.
//

import Foundation

public enum SFSymbol: String {
    case questionmark
    case plus
    case chevronBackward
    case checkmark
    case ellipsis
    case trash
}

// MARK: - Public methods
extension SFSymbol {
    public var systemName: String {
        switch self {
        case .questionmark:
            return rawValue

        case .plus:
            return rawValue

        case .chevronBackward:
            return "chevron.backward"

        case .checkmark:
            return rawValue

        case .ellipsis:
            return rawValue

        case .trash:
            return rawValue
        }
    }
}
