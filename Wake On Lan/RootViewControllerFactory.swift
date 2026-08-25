//
//  RootViewControllerFactory.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 6. 7. 2026..
//  Copyright © 2026 Vladislav Lisianskii. All rights reserved.
//

import SwiftUI
import UIKit

@MainActor
struct RootViewControllerFactory {
    /// Which flow to build. The default answers "UIKit", which is what a Release build ships; the
    /// debug menu supplies a different answer while the rewrite is in progress.
    var flowFlags: any ProvidesAppFlowFlags = DefaultAppFlowFlags()

    func build() -> UIViewController {
        flowFlags.isSwiftUIFlowEnabled ? buildSwiftUIFlow() : buildUIKitFlow()
    }

    private func buildUIKitFlow() -> UIViewController {
        let hostList = HostListFactory(router: WOLRouter()).build(with: nil)

        return WOLNavigationController(rootViewController: hostList)
    }

    /// The SwiftUI half, hosted in UIKit because the app still boots through a `UIWindow`. The
    /// wrapper is what lets both flows exist at once; it disappears with the last UIKit screen.
    private func buildSwiftUIFlow() -> UIViewController {
        UIHostingController(rootView: SwiftUIFlowRootView())
    }
}
