//
//  AwakeButtonMetrics.swift
//  Wake on LAN
//

import CoreGraphics

/// The numbers the design draws for buttons and gives no token for.
///
/// They live here rather than inside the button styles so that every value taken from the design
/// sits in one folder and can be audited against it in one pass. Section 03 has no 14 pt radius and
/// no 9 / 16 padding pair, and section 02 has no 13 pt semibold, so promoting these into
/// ``AwakeRadius``, ``AwakeSpacing`` or ``AwakeTextStyle`` would make those files claim tokens the
/// design does not have.
enum AwakeButtonMetrics {
    /// The glyph in the main button.
    static let primaryIconSize: CGFloat = 16

    /// The gap between a button's icon and its title.
    static let labelSpacing: CGFloat = 10

    /// Corner radius of a compact button. Two points off ``AwakeRadius/chip``, and not the same
    /// thing — the design draws both.
    static let compactRadius: CGFloat = 14
    static let compactVerticalPadding: CGFloat = 9
    static let compactHorizontalPadding: CGFloat = 16
    static let compactLabelSize: CGFloat = 13
    static let compactIconSize: CGFloat = 13

    /// Not in the design, which specifies no pressed state. A button with no feedback reads as
    /// broken, so this is the smallest thing that answers the tap.
    static let pressedOpacity: Double = 0.85
}
