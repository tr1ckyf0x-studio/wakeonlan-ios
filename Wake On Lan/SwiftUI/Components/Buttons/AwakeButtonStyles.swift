//
//  AwakeButtonStyles.swift
//  Wake on LAN
//

import SwiftUI

/// The screen's single main action, from the buttons block of design-system section 05.
///
/// Full width, 54 tall, accent fill, and a soft accent shadow beneath it. On the light theme it also
/// takes a 1 pt edge: the accent against `background` measures 1.41 : 1 there, so without the edge
/// the button has no discernible boundary. `AccentEdge` is that colour on light and fully
/// transparent on dark, where the fill already reaches 12.63 : 1 on its own — which keeps the theme
/// decision in the asset catalogue instead of in this view.
///
/// Design-system rule 1 allows one accent per screen, so there should be at most one of these
/// visible at a time.
struct AwakePrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .labelStyle(AwakeButtonLabelStyle(iconSize: AwakeButtonMetrics.primaryIconSize))
            .textStyle(.navTitle)
            .foregroundStyle(Color(.DesignSystem.onAccent))
            .frame(maxWidth: .infinity)
            .frame(height: AwakeSize.primaryButton)
            .background(Color(.DesignSystem.accent), in: .rect(cornerRadius: AwakeRadius.group))
            .overlay {
                RoundedRectangle(cornerRadius: AwakeRadius.group)
                    .strokeBorder(Color(.DesignSystem.accentEdge), lineWidth: AwakeSize.hairline)
            }
            .awakeShadow(.accent)
            .opacity(configuration.isPressed ? AwakeButtonMetrics.pressedOpacity : 1)
    }
}

/// The small buttons that sit in a row — a paywall's "Buy", a failed row's "Again".
///
/// The design gives these a 13 / 600 label, which section 02 does not tokenise: its only 13 pt style
/// is `caption` at weight 400. The size is therefore written out here rather than added to the type
/// scale, so the scale keeps matching the design's own list.
struct AwakeCompactButtonStyle: ButtonStyle {
    enum Emphasis {
        /// Accent fill — an affirmative action inside a card.
        case accent
        /// Chip fill — the neutral alternative next to an accent one.
        case secondary
        /// No fill, accent text — a repeat or a retry.
        case plain
    }

    let emphasis: Emphasis

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .labelStyle(AwakeButtonLabelStyle(iconSize: AwakeButtonMetrics.compactIconSize))
            .font(.system(size: AwakeButtonMetrics.compactLabelSize, weight: .semibold))
            .foregroundStyle(foreground)
            .padding(.vertical, AwakeButtonMetrics.compactVerticalPadding)
            .padding(.horizontal, AwakeButtonMetrics.compactHorizontalPadding)
            .background(background, in: .rect(cornerRadius: AwakeButtonMetrics.compactRadius))
            .opacity(configuration.isPressed ? AwakeButtonMetrics.pressedOpacity : 1)
    }

    private var foreground: Color {
        switch emphasis {
        case .accent: Color(.DesignSystem.onAccent)
        case .secondary: Color(.DesignSystem.textPrimary)
        case .plain: Color(.DesignSystem.accentText)
        }
    }

    private var background: Color {
        switch emphasis {
        case .accent: Color(.DesignSystem.accent)
        case .secondary: Color(.DesignSystem.chip)
        case .plain: .clear
        }
    }
}

// MARK: - Label

/// Lays a `Label` out the way the design draws a button's contents: the icon at a fixed size, then
/// the design's gap, then the title. Without it `Label` picks its own spacing from the font.
private struct AwakeButtonLabelStyle: LabelStyle {
    let iconSize: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: AwakeButtonMetrics.labelSpacing) {
            configuration.icon
                .font(.system(size: iconSize, weight: .semibold))
            configuration.title
        }
    }
}

// MARK: - ButtonStyle

extension ButtonStyle where Self == AwakePrimaryButtonStyle {
    /// The screen's single main action: full width, 54 tall, accent.
    static var awakePrimary: Self { AwakePrimaryButtonStyle() }
}

extension ButtonStyle where Self == AwakeCompactButtonStyle {
    /// A small button in a row. See ``AwakeCompactButtonStyle/Emphasis`` for which fill to use.
    static func awakeCompact(_ emphasis: AwakeCompactButtonStyle.Emphasis) -> Self {
        AwakeCompactButtonStyle(emphasis: emphasis)
    }
}

// MARK: - Previews

private struct AwakeButtonCatalogue: View {
    var body: some View {
        VStack(spacing: 14) {
            Button {
            } label: {
                Label("Add host", systemImage: "plus")
            }
            .buttonStyle(.awakePrimary)

            HStack(spacing: 10) {
                Button("Buy") {}
                    .buttonStyle(.awakeCompact(.accent))
                Button("Buy") {}
                    .buttonStyle(.awakeCompact(.secondary))
                Button("Again") {}
                    .buttonStyle(.awakeCompact(.plain))
                Spacer()
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.DesignSystem.background))
    }
}

#Preview("Dark") {
    AwakeButtonCatalogue()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    AwakeButtonCatalogue()
        .preferredColorScheme(.light)
}
