//
//  ShakeDetectingWindow.swift
//  Wake on LAN
//

#if DEBUG
import UIKit

/// A window that opens the debug menu when the device is shaken.
///
/// The gesture is caught at the window rather than in a view controller on purpose: the app is in
/// the middle of a rewrite and swaps its whole root between a UIKit and a SwiftUI flow, so anything
/// attached to a screen would have to be attached twice and would go missing on whichever flow was
/// forgotten. In the simulator the shortcut is ⌃⌘Z.
final class ShakeDetectingWindow: UIWindow {
    /// Called on shake. Set by whoever builds the window.
    var onShake: (() -> Void)?

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        guard motion == .motionShake else { return }
        onShake?()
    }
}
#endif
