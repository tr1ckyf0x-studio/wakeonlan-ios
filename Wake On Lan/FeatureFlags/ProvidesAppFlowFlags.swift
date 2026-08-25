//
//  ProvidesAppFlowFlags.swift
//  Wake on LAN
//

import Foundation

/// What the app asks about the flow it should present.
///
/// Declared here rather than imported from FoxDebug so that the code deciding which flow to build
/// carries no dependency on the debug menu — the menu is one possible answer to this question, and
/// in a Release build there is no menu at all.
@MainActor
protocol ProvidesAppFlowFlags: Sendable {
    /// Whether the SwiftUI rewrite is shown instead of the UIKit screens.
    var isSwiftUIFlowEnabled: Bool { get }
}

/// The answer when nothing can change it: the UIKit flow, which is what ships.
///
/// This is what a Release build uses. Once the SwiftUI half is complete the flag disappears
/// together with the UIKit screens, and so does this type.
@MainActor
struct DefaultAppFlowFlags: ProvidesAppFlowFlags {
    var isSwiftUIFlowEnabled: Bool { false }
}
