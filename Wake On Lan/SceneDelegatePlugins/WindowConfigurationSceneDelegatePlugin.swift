//
//  WindowConfigurationSceneDelegatePlugin.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 6. 7. 2026..
//  Copyright © 2026 Vladislav Lisianskii. All rights reserved.
//

#if DEBUG
import FoxDebugMenu
#endif
import SwiftUI
import UIKit

final class WindowConfigurationSceneDelegatePlugin: NSObject, UIWindowSceneDelegate {
    typealias ConfigureWindow = (_ window: UIWindow) -> Void

    private let rootViewControllerFactory: RootViewControllerFactory
    private let configureWindow: ConfigureWindow

    init(
        rootViewControllerFactory: RootViewControllerFactory? = nil,
        configureWindow: @escaping ConfigureWindow
    ) {
        // Not a default argument: `Self.flowFlags` is `@MainActor`, and a default argument cannot
        // reach it. The nil case is "use the flags this build ships with".
        self.rootViewControllerFactory = rootViewControllerFactory
            ?? RootViewControllerFactory(flowFlags: MainActor.assumeIsolated { Self.flowFlags })
        self.configureWindow = configureWindow
        super.init()
    }

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = Self.makeWindow(windowScene: windowScene)
        configureWindow(window)
        window.rootViewController = rootViewControllerFactory.build()
        window.makeKeyAndVisible()
    }

    @MainActor
    private static var flowFlags: any ProvidesAppFlowFlags {
        #if DEBUG
        DebugAppDelegatePlugin.shared.toggles
        #else
        DefaultAppFlowFlags()
        #endif
    }

    /// A Debug build gets a window that watches for a shake and presents the debug menu over
    /// whatever is on screen. A Release build gets a plain one.
    @MainActor
    private static func makeWindow(windowScene: UIWindowScene) -> UIWindow {
        #if DEBUG
        let window = ShakeDetectingWindow(windowScene: windowScene)
        window.onShake = { [weak window] in
            guard let window, window.rootViewController?.presentedViewController == nil else { return }

            let menu = UIHostingController(
                rootView: DebugMenuView(registry: DebugAppDelegatePlugin.shared.toggles.menuRegistry)
            )
            window.rootViewController?.present(menu, animated: true)
        }
        return window
        #else
        return UIWindow(windowScene: windowScene)
        #endif
    }
}
