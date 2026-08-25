//
//  HostStatus+Name.swift
//  Wake on LAN
//

import Foundation

extension HostStatus {
    /// The state in words.
    ///
    /// Design-system rule 4 requires the dot's colour to be repeated in words so that the difference
    /// between green and grey is never the only signal. The design draws those words only while
    /// something is happening — an idle row shows its MAC instead — so this is what the row hands to
    /// VoiceOver regardless of what it draws.
    var name: LocalizedStringResource {
        switch self {
        case .online: .hostStatusOnline
        case .offline: .hostStatusOffline
        case .probing: .hostStatusProbing
        case .waking: .hostStatusWaking
        case .unreachable: .hostStatusUnreachable
        case .unknown: .hostStatusUnknown
        }
    }
}
