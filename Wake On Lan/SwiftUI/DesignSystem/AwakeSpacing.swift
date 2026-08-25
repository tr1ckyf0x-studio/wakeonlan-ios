//
//  AwakeSpacing.swift
//  Wake on LAN
//

import CoreGraphics

/// The spacing scale of design-system section 03.
///
/// Where the design writes a range it is given as two values rather than averaged: the wider one is
/// for a card that stands alone, the tighter one for a card in a stack.
enum AwakeSpacing {
    /// 16 — the screen's own margins.
    static let screenMargin: CGFloat = 16

    /// 14 — padding inside a card, tight end of the design's 14–18.
    static let cardPaddingTight: CGFloat = 14
    /// 18 — padding inside a card, roomy end of the design's 14–18.
    static let cardPaddingRoomy: CGFloat = 18

    /// 12 — between two cards, and between a row's status dot, icon and text.
    static let betweenCards: CGFloat = 12

    /// 8 — from a section heading down to the group it introduces.
    static let sectionHeaderToGroup: CGFloat = 8

    /// 20 — from a group down to the next section heading, tight end of the design's 20–22.
    static let groupToNextSectionTight: CGFloat = 20
    /// 22 — the roomy end of the same gap.
    static let groupToNextSectionRoomy: CGFloat = 22

    /// 14 — how far a separator inside a group starts from the leading edge, so that it lines up
    /// with the text rather than with the card.
    static let separatorInset: CGFloat = 14

    /// 11 — above and below the content of a two-line list row.
    static let listRowVertical: CGFloat = 11
    /// 14 — the leading and trailing padding of a list row.
    static let listRowHorizontal: CGFloat = 14
}
