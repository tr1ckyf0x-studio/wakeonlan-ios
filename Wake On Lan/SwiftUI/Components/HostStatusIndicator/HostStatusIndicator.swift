//
//  HostStatusIndicator.swift
//  Wake on LAN
//

import SwiftUI

/// The host status dot documented by card 4b of the design system.
///
/// The six states resolve to four independent axes — fill, ring, glow and pulse — so the view maps
/// the status to a single `Appearance` value and renders it through one path. There are no branches
/// at all: a state that has no fill has a `.clear` one, and the same for the ring, which keeps the
/// view a single `Circle` across every state.
///
/// The dot is decorative. Design-system rule 4 requires the row to repeat the state in words, and
/// VoiceOver reads those words, so the dot itself is hidden from accessibility.
///
/// **The caller sizes it.** The view is built from `Circle`, which accepts whatever size it is
/// offered, so it needs a `.frame` — without one it grows to fill its row:
///
/// ```swift
/// HostStatusIndicator(status: host.status)
///     .frame(width: AwakeSize.statusDot, height: AwakeSize.statusDot)
/// ```
///
/// ``AwakeSize/statusDot`` is the diameter the design uses in every list row. Ring widths (2 and
/// 1) and the glow radius do **not** scale with the frame — the design keeps them absolute, and card 4b makes that
/// deliberate by drawing an 11 pt dot with the same 2 pt ring. Sizes far from 9 will look
/// off-proportion until the design supplies numbers for them.
struct HostStatusIndicator: View {
    // MARK: - Properties

    let status: HostStatus

    private var appearance: Appearance {
        Appearance(status: status)
    }

    /// Two phases cycle forever; one phase stands still. A `PhaseAnimator` loops through whatever it
    /// is given, so a state that does not pulse is expressed by handing it nothing to move between,
    /// rather than by switching the animation off.
    private var pulsePhases: [Bool] {
        appearance.isPulsing ? [false, true] : [false]
    }

    // MARK: - Body

    var body: some View {
        Circle()
            .strokeBorder(appearance.stroke, lineWidth: appearance.lineWidth)
            .background(appearance.fill, in: .circle)
            .shadow(color: appearance.glow, radius: AwakeShadow.statusGlow.radius)
            .phaseAnimator(pulsePhases) { dot, isCollapsed in
                dot
                    .scaleEffect(isCollapsed ? AwakeMotion.pulseScale : 1)
                    .opacity(isCollapsed ? AwakeMotion.pulseOpacity : 1)
            } animation: { _ in
                .easeInOut(duration: AwakeMotion.pulseDuration)
            }
            .accessibilityHidden(true)
    }
}

// MARK: - Appearance

extension HostStatusIndicator {
    /// The resolved look of one state. The design system encodes meaning as fill versus ring, ring
    /// weight, glow and motion, and every state is some combination of those four.
    ///
    /// There is no opacity axis: the design dropped the 60 % dimming that used to separate the
    /// offline dot from the online one, because it failed the 3 : 1 contrast threshold in both
    /// themes. Shape carries that distinction now — a filled disc against a 1 pt ring.
    fileprivate struct Appearance {
        /// `.clear` rather than `nil` on purpose. An absent fill or ring is a colour the state does
        /// not paint, not a view it does not have: keeping both unconditional means the rendered
        /// view is one shape for all six states, so SwiftUI never tears it down and rebuilds it when
        /// the status changes — which would drop the pulse mid-animation.
        var fill: Color = .clear
        var stroke: Color = .clear
        var lineWidth: CGFloat = 0

        /// The halo behind the dot. `StatusGlow` is the accent at alpha 1 for dark and alpha 0 for
        /// light, because the design turns the glow off on the light theme (`--stGlow: none`), so
        /// the view needs no knowledge of the colour scheme.
        var glow: Color = .clear
        var isPulsing = false
    }
}

// The mapping lives in its own extension so that `Appearance` keeps its memberwise initialiser —
// declaring `init(status:)` inside the struct would suppress it, and every case below delegates to
// it. Moving this init up into the type would not compile.
extension HostStatusIndicator.Appearance {
    init(status: HostStatus) {
        switch status {
        case .online:
            self.init(fill: Color(.DesignSystem.statusOn), glow: Color(.DesignSystem.statusGlow))

        case .offline:
            self.init(fill: Color(.DesignSystem.statusQuiet))

        case .probing:
            self.init(stroke: Color(.DesignSystem.statusQuiet), lineWidth: AwakeSize.statusRingPolling, isPulsing: true)

        case .waking:
            self.init(stroke: Color(.DesignSystem.statusOn), lineWidth: AwakeSize.statusRingPolling, isPulsing: true)

        case .unreachable:
            self.init(fill: Color(.DesignSystem.warning))

        case .unknown:
            self.init(stroke: Color(.DesignSystem.statusQuiet), lineWidth: AwakeSize.statusRingIdle)
        }
    }
}

// MARK: - Previews

/// Preview-only catalogue of all six states.
///
/// The labels are the case names rather than the wording card 4b uses, and rather than
/// string-catalogue keys: the localised status names arrive with the host row, which is what will
/// actually show them to a user. Taking them from the case itself also keeps them right through a
/// rename.
private struct HostStatusCatalogue: View {
    /// The size card 4b itself draws. Two points over the 9 pt a list row uses is enough to tell a
    /// 2 pt ring from a 1 pt one in a static snapshot, without misrepresenting how the dot looks in
    /// a row.
    private let showcaseSize: CGFloat = 11

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(HostStatus.allCases, id: \.self) { status in
                HStack(spacing: 14) {
                    HostStatusIndicator(status: status)
                        .frame(width: showcaseSize, height: showcaseSize)
                    Text(String(describing: status))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color(.DesignSystem.textPrimary))
                }
                .padding(.vertical, 14)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.DesignSystem.surface))
    }
}

#Preview("Dark") {
    HostStatusCatalogue()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    HostStatusCatalogue()
        .preferredColorScheme(.light)
}
