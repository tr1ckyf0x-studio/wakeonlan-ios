//
//  SwiftUIFlowRootView.swift
//  Wake on LAN
//

import SwiftUI

/// The root of the SwiftUI flow while that flow is still being built.
///
/// Temporary scaffolding: it exists so the flag has something to show and so the design-system
/// components can be judged on a device rather than in a preview canvas. Every screen replaces a
/// part of it, and it is gone once the host list lands.
struct SwiftUIFlowRootView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AwakeSpacing.groupToNextSectionTight) {
                    section("Host status") {
                        VStack(alignment: .leading, spacing: AwakeSpacing.betweenCards) {
                            ForEach(HostStatus.allCases, id: \.self) { status in
                                HStack(spacing: AwakeSpacing.betweenCards) {
                                    HostStatusIndicator(status: status)
                                        .frame(width: AwakeSize.statusDot, height: AwakeSize.statusDot)
                                    Text(status.name)
                                        .textStyle(.rowTitle)
                                        .foregroundStyle(Color(.DesignSystem.textPrimary))
                                }
                            }
                        }
                    }

                    section("Buttons") {
                        VStack(spacing: AwakeSpacing.betweenCards) {
                            Button {
                            } label: {
                                Label("Add host", systemImage: "plus")
                            }
                            .buttonStyle(.awakePrimary)

                            HStack(spacing: AwakeSpacing.betweenCards) {
                                Button("Buy") {}
                                    .buttonStyle(.awakeCompact(.accent))
                                Button("Buy") {}
                                    .buttonStyle(.awakeCompact(.secondary))
                                Button("Again") {}
                                    .buttonStyle(.awakeCompact(.plain))
                                Spacer()
                            }
                        }
                    }
                }
                .padding(AwakeSpacing.screenMargin)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color(.DesignSystem.background))
            .navigationTitle("SwiftUI flow")
        }
    }

    private func section(
        _ title: String,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: AwakeSpacing.sectionHeaderToGroup) {
            Text(title)
                .textStyle(.overline)
                .foregroundStyle(Color(.DesignSystem.textTertiary))
            content()
        }
    }
}

#Preview("Dark") {
    SwiftUIFlowRootView()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    SwiftUIFlowRootView()
        .preferredColorScheme(.light)
}
