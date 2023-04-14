//
//  SFSymbol.swift
//  
//
//  Created by Vladislav Lisianskii on 31.07.2021.
//

import Foundation

// MARK: - SFSymbolFactory

public enum SFSymbolFactory {
    private typealias SymbolType = SFSymbolRepresentable & RawStringInitable

    private static let hostTypes: [SymbolType.Type] = [ButtonIcon.self, HostIcon.self]

    public static func build(from rawValue: String) -> SFSymbolRepresentable? {
        hostTypes.lazy.compactMap { $0.init(rawString: rawValue) }.first
    }
}

// MARK: - SFSymbolRepresentable

public protocol SFSymbolRepresentable {
    var systemName: String { get }
}

public extension SFSymbolRepresentable where Self: RawRepresentable, RawValue == String {
    var systemName: String { rawValue }
}

// MARK: - ButtonIcon

public enum ButtonIcon: String, SFSymbolRepresentable, RawStringInitable {
    case checkmark
    case chevronBackward = "chevron.backward"
    case ellipsis
    case plus
    case questionmark
    case trash
    case star = "star.fill"
    case share = "square.and.arrow.up"
    case tag
    case bitcoin = "bitcoinsign.circle.fill"
    case dollar = "dollarsign.circle.fill"
}

// MARK: - HostIcon

public enum HostIcon: String, CaseIterable, SFSymbolRepresentable, RawStringInitable {
    case desktopcomputer
    case externalDriveConnected = "externaldrive.connected.to.line.below"
    case externalDriveWifi = "externaldrive.badge.wifi"
    case laptopcomputer
    case macproGen1 = "macpro.gen1"
    case macproGen3 = "macpro.gen3"
    case macmini
    case pc
    case printer
    case scanner
    case serverRack = "server.rack"
    case tv
    case xserve
}

// MARK: - Private

private protocol RawStringInitable {
    init?(rawString: String)
}

private extension RawStringInitable where Self: RawRepresentable, RawValue == String {
    init?(rawString: String) {
        self.init(rawValue: rawString)
    }
}
