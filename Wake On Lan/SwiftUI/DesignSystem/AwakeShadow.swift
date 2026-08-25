//
//  AwakeShadow.swift
//  Wake on LAN
//

import SwiftUI

/// The shadows of design-system section 01, geometry included.
///
/// The asset catalogue can hold a shadow's colour but not its offset or blur, so the two halves of
/// each token meet here. CSS blur is 2σ where a SwiftUI shadow radius is σ, so every blur is halved.
/// CSS spread has no SwiftUI equivalent and is dropped, which makes each shadow reach slightly
/// further than the design draws it.
struct AwakeShadow {
    let color: Color
    let radius: CGFloat
    let offsetY: CGFloat

    /// `0 12px 30px -12px accent 75%` — under the screen's main button.
    static let accent = Self(
        color: Color(.DesignSystem.shadowAccent),
        radius: 15,
        offsetY: 12
    )

    /// `0 34px 74px -26px` — under a sheet.
    static let sheet = Self(
        color: Color(.DesignSystem.shadowSheet),
        radius: 37,
        offsetY: 34
    )

    /// `0 0 10px` around the dot of a host that answered. `StatusGlow` is transparent on the light
    /// theme, where the design turns the glow off.
    static let statusGlow = Self(
        color: Color(.DesignSystem.statusGlow),
        radius: 5,
        offsetY: 0
    )
}

extension View {
    /// Applies a design-system shadow, colour and geometry together.
    func awakeShadow(_ shadow: AwakeShadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, y: shadow.offsetY)
    }
}
