//
//  AwakeFeatureFlags.swift
//  Wake on LAN
//

#if DEBUG
import FoxFeatureToggle

extension FeatureFlagGroup {
    static let flow = FeatureFlagGroup(rawValue: "Flow")
}

/// Every flag the debug menu can override.
///
/// `@FeatureFlagContainer` generates `all` from the members marked `@FeatureToggle`, which is what
/// the registry is handed at launch. Flags must be `static var`, not `static let` — the macro is an
/// accessor macro and needs a property it can supply a getter for.
@FeatureFlagContainer
enum AwakeFeatureFlags {
    /// `.development` on purpose: a remote value must never be able to switch a user onto a rewrite
    /// that is still being built. Only the debug menu can turn this on.
    @FeatureToggle(
        displayName: "SwiftUI flow",
        group: .flow,
        stage: .development
    )
    static var swiftUIFlow: FeatureFlag
}
#endif
