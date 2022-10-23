//
//  WindowConfigurationAppDelegatePlugin.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 23.10.2022.
//  Copyright © 2022 Владислав Лисянский. All rights reserved.
//

import PostLaunch
import SharedRouter
import UIKit
import WOLUIComponents

final class WindowConfigurationAppDelegatePlugin: NSObject, UIApplicationDelegate {

    typealias ConfigureWindow = (_ window: UIWindow) -> Void

    private let configureWindow: ConfigureWindow

    init(configureWindow: @escaping ConfigureWindow) {
        self.configureWindow = configureWindow
        super.init()
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        configureWindow(window)
        window.rootViewController = WOLNavigationController(rootViewController: {
            let factory = PostLaunchFactory(router: WOLRouter())
            guard
                let viewController = try? factory.build(with: nil)
            else {
                fatalError("Root view controller wasn't built")
            }

            return viewController
        }())
        window.makeKeyAndVisible()
        return true
    }
}
