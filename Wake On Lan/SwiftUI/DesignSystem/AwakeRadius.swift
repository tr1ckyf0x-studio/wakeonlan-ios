//
//  AwakeRadius.swift
//  Wake on LAN
//

import CoreGraphics

/// The corner radii of design-system section 03.
///
/// Named after what each radius is for rather than after its value, because the design assigns them
/// by role: a chip and a tile differ by one point, and only the role says which is which.
enum AwakeRadius {
    /// 6 — a keyboard key.
    static let key: CGFloat = 6
    /// 9 — a pill.
    static let pill: CGFloat = 9
    /// 12 — an icon tile.
    static let tile: CGFloat = 12
    /// 13 — a group chip or a segment.
    static let chip: CGFloat = 13
    /// 16 — a group of rows, and the main button.
    static let group: CGFloat = 16
    /// 22 — a form field.
    static let field: CGFloat = 22
    /// 24 — a sheet.
    static let sheet: CGFloat = 24
    /// 32 — the extra-large icon on the about screen.
    static let iconXL: CGFloat = 32
}
