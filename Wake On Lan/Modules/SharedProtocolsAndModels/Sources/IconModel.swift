//
//  IconModel.swift
//  WOLUIComponents
//
//  Created by Dmitry on 13.12.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import WOLResources

public protocol IconModelRepresentable {
    var sfSymbol: SFSymbolRepresentable { get }
}

public struct IconModel: IconModelRepresentable {
    public let sfSymbol: SFSymbolRepresentable

    public init(sfSymbol: SFSymbolRepresentable = HostIcon.desktopcomputer) {
        self.sfSymbol = sfSymbol
    }
}

// MARK: - Equatable

extension IconModel: Equatable {
    public static func == (lhs: IconModel, rhs: IconModel) -> Bool {
        lhs.sfSymbol.systemName == rhs.sfSymbol.systemName
    }
}
