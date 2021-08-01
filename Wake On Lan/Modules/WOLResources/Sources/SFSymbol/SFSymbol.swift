//
//  SFSymbol.swift
//  
//
//  Created by Vladislav Lisianskii on 31.07.2021.
//

import Foundation

public protocol SFSymbolRepresentable {
    var systemName: String { get }
}

private protocol RawStringInitializable {
    init?(rawString: String)
}

private extension RawStringInitializable where Self: RawRepresentable, RawValue == String {
    init?(rawString: String) {
        self.init(rawValue: rawString)
    }
}

public extension SFSymbolRepresentable where Self: RawRepresentable, RawValue == String {
    var systemName: String {
        rawValue
    }
}

public enum ButtonIcon: String, SFSymbolRepresentable, RawStringInitializable {
    case questionmark
    case plus
    case chevronBackward = "chevron.backward"
    case checkmark
    case ellipsis
    case trash
}

public enum HostIcon: String, CaseIterable, SFSymbolRepresentable, RawStringInitializable {
    case desktopcomputer
    case tv
    case pc
    case macproGen1 = "macpro.gen1"
    case macproGen3 = "macpro.gen3"
    case serverRack = "server.rack"
    case xserve
    case laptopcomputer
    case macmini
    case printer
    case scanner
    case externalDriveConnected = "externaldrive.connected.to.line.below"
    case externalDriveWifi = "externaldrive.badge.wifi"
}

public enum SFSymbolRepresentableFactory {
    private typealias SymbolType = SFSymbolRepresentable & RawStringInitializable

    private static let hostTypes = [ButtonIcon.self, HostIcon.self] as [SymbolType.Type]

    public static func sfSymbolRepresentable(for rawValue: String) -> SFSymbolRepresentable? {
        hostTypes.lazy.compactMap { type -> SFSymbolRepresentable? in
            type.init(rawString: rawValue)
        }.first
    }
}
