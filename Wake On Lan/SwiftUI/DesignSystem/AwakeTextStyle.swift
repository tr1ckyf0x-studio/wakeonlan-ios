//
//  AwakeTextStyle.swift
//  Wake on LAN
//

import SwiftUI
import UIKit

/// The type scale of section 02 of the design system.
///
/// A style carries everything the design specifies about a piece of text except its colour: size,
/// weight, typeface design, line height, tracking and letter case. Colour stays out because the
/// design assigns it per context — `nav-action` is the same type as any 16 pt semibold label and
/// differs only by being drawn in the accent.
///
/// Apply with ``SwiftUI/View/textStyle(_:)`` rather than reaching for `.font` directly: tracking is
/// not part of `Font`, so a bare `.font(...)` silently drops it.
enum AwakeTextStyle: Hashable, CaseIterable {
    /// 30 / 1.15 · 700 · −0.8
    case titleL
    /// 24 · 700 · −0.5
    case titleM
    /// 22 · 700 · −0.5
    case titleS
    /// 17 · 600 · −0.2 — navigation bar title
    case navTitle
    /// 16 · 600 — navigation bar action, drawn in the accent by its caller
    case navAction
    /// 17 / 1.1 · 400 — a value inside a form field
    case fieldValue
    /// 17 / 1.1 · 400 · +0.5 · monospaced — an address inside a form field
    case fieldValueMono
    /// 11 · 600 · +0.8 · caps — the label inside a form field
    case fieldLabel
    /// 16 · 500 · −0.2 — a host name in a list row
    case rowTitle
    /// 14 · 500 · radius 13 chip
    case chipLabel
    /// 14 · 600 — the selected chip
    case chipLabelSelected
    /// 13 / 1.4 · 400
    case caption
    /// 12 / 1.45 · 400 — the explanation under a field
    case hint
    /// 11 · 600 · +1.3 · caps — a section heading
    case overline
    /// 11 / 1.3 · 400 · +0.3 · monospaced — addresses and the log
    case monoS
    /// 10 · 600 · +0.5 · caps — on an accent fill
    case badge
}

// MARK: - View

extension View {
    /// Applies a design-system text style: font, tracking, line height and letter case at once.
    func textStyle(_ style: AwakeTextStyle) -> some View {
        modifier(AwakeTextStyleModifier(style: style))
    }
}

private struct AwakeTextStyleModifier: ViewModifier {
    let style: AwakeTextStyle

    func body(content: Content) -> some View {
        let metrics = AwakeTextStyle.Metrics(style: style)

        content
            .font(metrics.font)
            .tracking(metrics.tracking)
            .lineSpacing(metrics.lineSpacing)
            .textCase(metrics.isUppercased ? .uppercase : nil)
    }
}

// MARK: - Metrics

extension AwakeTextStyle {
    /// One row of the type scale, in the design's own terms.
    fileprivate struct Metrics {
        var size: CGFloat
        var weight: Font.Weight = .regular
        var isMonospaced = false

        /// A multiple of the size, the way the design writes it (`13 / 1.4`). Styles the design
        /// gives no ratio for are single-line and stay at 1.
        var lineHeight: CGFloat = 1
        var tracking: CGFloat = 0
        var isUppercased = false
    }
}

// The mapping lives in its own extension so that `Metrics` keeps its memberwise initialiser, which
// every case below delegates to.
extension AwakeTextStyle.Metrics {
    var font: Font {
        isMonospaced
            ? .system(size: size, weight: weight, design: .monospaced)
            : .system(size: size, weight: weight)
    }

    /// SwiftUI's `lineSpacing` is the gap *added between* lines, while the design writes line height
    /// as a multiple of the size. The gap is therefore the difference between the two, and the font's
    /// own line height — which is already taller than its point size — has to be measured rather
    /// than assumed.
    var lineSpacing: CGFloat {
        guard lineHeight > 1 else { return 0 }

        let uiWeight = UIFont.Weight(rawValue: weight.uiKitRawValue)
        let natural = isMonospaced
            ? UIFont.monospacedSystemFont(ofSize: size, weight: uiWeight).lineHeight
            : UIFont.systemFont(ofSize: size, weight: uiWeight).lineHeight

        return max(0, size * lineHeight - natural)
    }

    init(style: AwakeTextStyle) {
        switch style {
        case .titleL:
            self.init(size: 30, weight: .bold, lineHeight: 1.15, tracking: -0.8)

        case .titleM:
            self.init(size: 24, weight: .bold, tracking: -0.5)

        case .titleS:
            self.init(size: 22, weight: .bold, tracking: -0.5)

        case .navTitle:
            self.init(size: 17, weight: .semibold, tracking: -0.2)

        case .navAction:
            self.init(size: 16, weight: .semibold)

        case .fieldValue:
            self.init(size: 17, lineHeight: 1.1)

        case .fieldValueMono:
            self.init(size: 17, isMonospaced: true, lineHeight: 1.1, tracking: 0.5)

        case .fieldLabel:
            self.init(size: 11, weight: .semibold, tracking: 0.8, isUppercased: true)

        case .rowTitle:
            self.init(size: 16, weight: .medium, tracking: -0.2)

        case .chipLabel:
            self.init(size: 14, weight: .medium)

        case .chipLabelSelected:
            self.init(size: 14, weight: .semibold)

        case .caption:
            self.init(size: 13, lineHeight: 1.4)

        case .hint:
            self.init(size: 12, lineHeight: 1.45)

        case .overline:
            self.init(size: 11, weight: .semibold, tracking: 1.3, isUppercased: true)

        case .monoS:
            self.init(size: 11, isMonospaced: true, lineHeight: 1.3, tracking: 0.3)

        case .badge:
            self.init(size: 10, weight: .semibold, tracking: 0.5, isUppercased: true)
        }
    }
}

// `Font.Weight` carries no way to reach the matching `UIFont.Weight`, and the two are the same set
// of values, so the bridge is written out once here rather than at every measurement.
private extension Font.Weight {
    var uiKitRawValue: CGFloat {
        switch self {
        case .ultraLight: UIFont.Weight.ultraLight.rawValue
        case .thin: UIFont.Weight.thin.rawValue
        case .light: UIFont.Weight.light.rawValue
        case .medium: UIFont.Weight.medium.rawValue
        case .semibold: UIFont.Weight.semibold.rawValue
        case .bold: UIFont.Weight.bold.rawValue
        case .heavy: UIFont.Weight.heavy.rawValue
        case .black: UIFont.Weight.black.rawValue
        default: UIFont.Weight.regular.rawValue
        }
    }
}

// MARK: - Previews

/// Preview-only specimen of the whole scale, in the order section 02 lists it.
private struct AwakeTextStyleSpecimen: View {
    private let samples: [(AwakeTextStyle, String)] = [
        (.titleL, "Thank you for using"),
        (.titleM, "Awake"),
        (.titleS, "499 ₽"),
        (.navTitle, "New host"),
        (.fieldValue, "Gaming PC"),
        (.fieldValueMono, "FF:AA:11:FD:FF:FF"),
        (.rowTitle, "Home server"),
        (.navAction, "Done"),
        (.chipLabelSelected, "Home"),
        (.chipLabel, "Office"),
        (.caption, "A small thank you"),
        (.hint, "Your computer's MAC address. You can find it in the Ethernet network settings."),
        (.overline, "Home · 3"),
        (.fieldLabel, "MAC address"),
        (.monoS, "09:41 · Gaming PC · sent"),
        (.badge, "Most chosen")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ForEach(Array(samples.enumerated()), id: \.offset) { _, sample in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(describing: sample.0))
                            .textStyle(.monoS)
                            .foregroundStyle(Color(.DesignSystem.textTertiary))
                        Text(sample.1)
                            .textStyle(sample.0)
                            .foregroundStyle(Color(.DesignSystem.textPrimary))
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color(.DesignSystem.background))
    }
}

#Preview("Dark") {
    AwakeTextStyleSpecimen()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    AwakeTextStyleSpecimen()
        .preferredColorScheme(.light)
}
