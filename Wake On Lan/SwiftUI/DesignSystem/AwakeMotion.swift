//
//  AwakeMotion.swift
//  Wake on LAN
//

import SwiftUI

/// The motion the design specifies, from section 04.
enum AwakeMotion {
    /// Half of the 1.1 s pulse the design writes as a CSS cycle. A CSS duration covers the whole
    /// there-and-back run, while this is one leg of it — two legs make the round trip. Reading it
    /// as 1.1 here would halve the speed.
    static let pulseDuration: TimeInterval = 0.55
    /// The pulse shrinks to 82 % at its narrowest.
    static let pulseScale: CGFloat = 0.82
    /// …and fades to 55 % at the same moment.
    static let pulseOpacity: Double = 0.55
}
