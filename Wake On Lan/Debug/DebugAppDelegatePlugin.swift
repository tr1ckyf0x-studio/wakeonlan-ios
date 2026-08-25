//
//  DebugAppDelegatePlugin.swift
//  Wake on LAN
//

#if DEBUG
import UIKit

/// Holds the feature-toggle stack for the lifetime of the process.
///
/// It configures nothing at launch — like `IAPAppDelegatePlugin`, it exists to own an object that
/// must outlive any one screen. The scene reads ``toggles`` from it when it builds the root, and the
/// debug menu writes to the same instance, so a flag flipped in the menu is the flag the next launch
/// reads.
final class DebugAppDelegatePlugin: NSObject, UIApplicationDelegate {
    @MainActor static let shared = DebugAppDelegatePlugin()

    @MainActor let toggles = DebugFeatureToggles()
}
#endif
