//
//  AppDelegate.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 24.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CoreDataService
import HostList
import UIKit
import WOLResources
import WOLUIComponents

@MainActor
@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let coreDataService: CoreDataServiceProtocol = CoreDataService.shared

    var plugins: [UIApplicationDelegate] = [
        DDLogAppDelegatePlugin(),
        FirebaseAppDelegatePlugin(),
        NavigationBarAppearanceAppDelegatePlugin()
    ]

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        plugins.forEach { _ = $0.application?(application, didFinishLaunchingWithOptions: launchOptions) }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = WOLNavigationController(rootViewController: {
            let factory = PostLaunchFactory(router: WOLRouter())
            guard
                let viewController = try? factory.build(with: nil)
            else {
                fatalError("Root view controller wasn't built")
            }

            return viewController
        }())
        window?.makeKeyAndVisible()

        return true
    }
}
