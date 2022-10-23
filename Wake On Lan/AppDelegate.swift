//
//  AppDelegate.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 24.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private lazy var plugins: [UIApplicationDelegate] = [
        DDLogAppDelegatePlugin(),
        FirebaseAppDelegatePlugin(),
        NavigationBarAppearanceAppDelegatePlugin(),
        WindowConfigurationAppDelegatePlugin(configureWindow: { [weak self] in self?.window = $0 })
    ]

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        plugins.forEach { _ = $0.application?(application, didFinishLaunchingWithOptions: launchOptions) }
        return true
    }
}
