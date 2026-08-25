//
//  DebugFeatureToggles.swift
//  Wake on LAN
//

#if DEBUG
import FoxDebugMenu
import FoxFeatureToggle
import FoxFeatureToggleUI
import SwiftUI

/// Owns the feature-toggle stack for the lifetime of the process, and answers the app's flow
/// question from it.
///
/// A single instance held by ``DebugAppDelegatePlugin``. The override store is
/// `UserDefaults`-backed, so a flag flipped in the menu survives a relaunch — which is the whole
/// point while a rewrite is in progress.
@MainActor
final class DebugFeatureToggles: ProvidesAppFlowFlags {
    let menuRegistry = DebugMenuRegistry()

    private let overrideStore: any FeatureToggleOverrideStore = UserDefaultsFeatureToggleOverrideStore()
    private let provider: FeatureToggleProvider
    private let flagRegistry = FeatureFlagRegistry()

    init() {
        provider = FeatureToggleProvider(overrideStore: overrideStore)
        flagRegistry.register(AwakeFeatureFlags.all)
        menuRegistry.register(
            FeatureToggleDebugSection(
                provider: provider,
                registry: flagRegistry,
                overrideStore: overrideStore
            )
        )
    }

    var isSwiftUIFlowEnabled: Bool {
        provider.isEnabled(AwakeFeatureFlags.swiftUIFlow)
    }
}
#endif
