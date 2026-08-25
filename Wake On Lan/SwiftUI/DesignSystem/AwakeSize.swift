//
//  AwakeSize.swift
//  Wake on LAN
//

import CoreGraphics

/// The fixed dimensions of design-system section 03, plus the status dot of section 04.
///
/// Design-system rule 6 sets the minimum tap target at 44; every interactive height here clears it.
enum AwakeSize {
    /// 54 — a single-line list row.
    static let listRowSingleLine: CGFloat = 54
    /// 46 — the navigation bar.
    static let navigationBar: CGFloat = 46
    /// 54 — the screen's main button.
    static let primaryButton: CGFloat = 54
    /// 20 — the device icon in a list row.
    static let deviceIcon: CGFloat = 20
    /// 9 — the host status dot, at every size the design draws it in a row.
    static let statusDot: CGFloat = 9
    /// 2 — the status dot's ring while a host is being polled or woken.
    static let statusRingPolling: CGFloat = 2
    /// 1 — the status dot's ring when there is nothing to poll. Thinner on purpose: section 04
    /// separates "asking" from "cannot ask" by ring weight as well as by motion.
    static let statusRingIdle: CGFloat = 1
    /// 1 — a hairline separator or outline. A point rather than a pixel, as the design draws it.
    static let hairline: CGFloat = 1
}
