//
//  SceneDelegate.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 6. 7. 2026..
//  Copyright © 2026 Vladislav Lisianskii. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var plugins: [UIWindowSceneDelegate] = [
        WindowConfigurationSceneDelegatePlugin(configureWindow: { [weak self] in self?.window = $0 })
    ]

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        plugins.forEach { $0.scene?(scene, willConnectTo: session, options: connectionOptions) }
    }
}
