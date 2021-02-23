//
//  NavigationBarAppearanceAppDelegatePlugin.swift
//  Wake on LAN
//
//  Created by Dmitry on 14.02.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import UIKit
import WOLResources

final class NavigationBarAppearanceAppDelegatePlugin: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Change background color
        UINavigationBar.appearance().barTintColor = R.color.soft()

        // Remove bottom line
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)

        // Change color of tappable items
        UINavigationBar.appearance().tintColor = R.color.soft()
        UINavigationBar.appearance().isTranslucent = false

        return true
    }
}
