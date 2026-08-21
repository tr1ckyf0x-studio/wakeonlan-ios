//
//  HostIcon.swift
//
//
//  Created by Vladislav Lisianskii on 31.07.2021.
//

import SFSafeSymbols

/// Curated set of device icons a user can pick for a host.
///
/// This is a domain list, not a wrapper around `SFSymbol`: it drives the icon picker
/// (`ChooseIcon` renders `allCases`) and guards persistence — `init(systemName:)` rejects any
/// name that is not part of the set.
///
/// - Important: `systemName` is persisted in `Host.iconName`. Removing a case or repointing it at
///   a different symbol orphans the icon of every host already saved with it.
public enum HostIcon: CaseIterable {
    case desktopcomputer
    case externalDriveConnected
    case externalDriveWifi
    case laptopcomputer
    case macproGen1
    case macproGen3
    case macmini
    case pc
    case printer
    case scanner
    case serverRack
    case tv
    case xserve

    /// Type-safe SF Symbol backing this icon.
    public var symbol: SFSymbol {
        switch self {
        case .desktopcomputer: .desktopcomputer
        case .externalDriveConnected: .externaldriveConnectedToLineBelow
        case .externalDriveWifi: .externaldriveBadgeWifi
        case .laptopcomputer: .laptopcomputer
        case .macproGen1: .macproGen1
        case .macproGen3: .macproGen3
        case .macmini: .macmini
        case .pc: .pc
        case .printer: .printer
        case .scanner: .scanner
        case .serverRack: .serverRack
        case .tv: .tv
        case .xserve: .xserve
        }
    }

    /// Raw symbol name, e.g. `"server.rack"`. This is the value stored in `Host.iconName`.
    public var systemName: String { symbol.rawValue }

    /// Restores an icon from its persisted name. Returns `nil` for a name outside the set.
    public init?(systemName: String) {
        guard
            let match = Self.allCases.first(where: { $0.systemName == systemName })
        else { return nil }
        self = match
    }
}
