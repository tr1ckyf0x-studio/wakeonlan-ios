//
//  SFSymbolRepresentable.swift
//  SharedProtocolsAndModels
//
//  Created by Vladislav Lisianskii on 19.11.2023.
//

import Foundation

// MARK: - SFSymbolRepresentable

public protocol SFSymbolRepresentable {
    var systemName: String { get }
}

public extension SFSymbolRepresentable where Self: RawRepresentable, RawValue == String {
    var systemName: String { rawValue }
}
