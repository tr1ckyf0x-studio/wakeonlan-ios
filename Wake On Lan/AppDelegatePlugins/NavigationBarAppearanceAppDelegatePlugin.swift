//
//  NavigationBarAppearanceAppDelegatePlugin.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 10.12.2021.
//  Copyright © 2021 Vladislav Lisianskii. All rights reserved.
//

import UIKit

final class NavigationBarAppearanceAppDelegatePlugin: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationBarAppearance.backgroundColor = UIColor(resource: .primary)
        navigationBarAppearance.shadowColor = nil
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        return true
    }
}
