//
//  AppDelegate.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 24.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import Resolver
import CoreDataService
import HostList
import WOLResources

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    @Injected private var coreDataService: CoreDataServiceProtocol

    var plugins: [UIApplicationDelegate] = [
        DDLogAppDelegatePlugin(),
        FirebaseAppDelegatePlugin(),
        FontRegisterAppDelegatePlugin()
    ]

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        plugins.forEach {
            _ = $0.application?(application, didFinishLaunchingWithOptions: launchOptions)
        }
        coreDataService.createHostContainer { [unowned self] in
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let hostListViewController = HostListViewController()
            let hostListConfigurator = HostListConfigurator()
            hostListConfigurator.configure(viewController: hostListViewController)
            let navigationController = UINavigationController(
                rootViewController: hostListViewController
            )

            // Change background color.
            UINavigationBar.appearance().barTintColor = R.color.soft()

            // Remove bottom line
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)

            // To change colour of tappable items.
            UINavigationBar.appearance().tintColor = R.color.soft()
            UINavigationBar.appearance().isTranslucent = false

            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        return true
    }

}
