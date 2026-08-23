//
//  UIBarButtonItem+SoftUI.swift
//  Wake on LAN
//

import UIKit

public extension UIBarButtonItem {
    /// A bar button whose content is a neumorphic `SoftUIView`.
    ///
    /// - Note: from iOS 26 the bar draws a shared background — the Glass effect — behind every item.
    ///   Behind a `SoftUIView`, which already draws its own shape and shadows, that reads as a second
    ///   brighter capsule around the control: the bubble. `hidesSharedBackground` opts this item out,
    ///   which is what the design system needs, since the button is not a system button pretending to
    ///   be one but a shape drawn from scratch.
    convenience init(softUIView view: SoftUIView) {
        self.init(customView: view)
        if #available(iOS 26.0, *) {
            hidesSharedBackground = true
        }
    }
}
