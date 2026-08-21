//
//  WindowConfigurationSceneDelegatePlugin.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 6. 7. 2026..
//  Copyright © 2026 Vladislav Lisianskii. All rights reserved.
//

import UIKit

final class WindowConfigurationSceneDelegatePlugin: NSObject, UIWindowSceneDelegate {
    typealias ConfigureWindow = (_ window: UIWindow) -> Void

    private let rootViewControllerFactory: RootViewControllerFactory
    private let configureWindow: ConfigureWindow

    init(
        rootViewControllerFactory: RootViewControllerFactory = RootViewControllerFactory(),
        configureWindow: @escaping ConfigureWindow
    ) {
        self.rootViewControllerFactory = rootViewControllerFactory
        self.configureWindow = configureWindow
        super.init()
    }

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        configureWindow(window)
        window.rootViewController = rootViewControllerFactory.build()
        window.makeKeyAndVisible()
    }
}
