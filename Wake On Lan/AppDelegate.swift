//
//  AppDelegate.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 24.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import Resolver

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    @Injected private var coreDataService: PersistentCoreDataService

    // swiftlint:disable line_length
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        coreDataService.createHostContainer { [unowned self] in
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let hostListViewController = HostListViewController()
            let navigationController = UINavigationController(rootViewController: hostListViewController)
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        return true
    }

}
