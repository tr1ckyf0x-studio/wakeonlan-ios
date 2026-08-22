//
//  SoftUITraits.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 22. 8. 2026..
//

import UIKit

/// The traits that change how an asset colour resolves.
///
/// - Note: this is the iOS 17 replacement for `traitCollection.hasDifferentColorAppearance(comparedTo:)`
///   inside `traitCollectionDidChange`, which is deprecated. The soft-UI controls bake resolved
///   colours into `CALayer` shadows, so they have to repaint themselves when any of these changes —
///   layers do not resolve dynamic colours on their own.
enum SoftUITraits {
    /// Computed rather than stored: `[any UITrait]` is not `Sendable`, so a `static let` would be
    /// rejected as unsafe global state.
    static var colorAppearance: [any UITrait] {
        [
            UITraitUserInterfaceStyle.self,
            UITraitUserInterfaceLevel.self,
            UITraitAccessibilityContrast.self
        ]
    }
}
