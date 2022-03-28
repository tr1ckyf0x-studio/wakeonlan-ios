//
//  AppDelegate.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 24.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CoreDataService
import HostList
import Resolver
import UIKit
import WOLResources
import WOLUIComponents

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    @Injected private var coreDataService: CoreDataServiceProtocol

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
        coreDataService.createHostContainer { [weak self] in
            guard let self = self else { return }
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let hostListViewController = HostListViewController()
            let hostListConfigurator = HostListConfigurator()
            hostListConfigurator.configure(viewController: hostListViewController)
            let navigationController = WOLNavigationController(rootViewController: hostListViewController)
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        return true
    }

}
