//
//  RootViewControllerFactory.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 6. 7. 2026..
//  Copyright © 2026 Vladislav Lisianskii. All rights reserved.
//

import UIKit

@MainActor
struct RootViewControllerFactory {

    func build() -> UIViewController {
        WOLNavigationController(rootViewController: {
            let factory = HostListFactory(router: WOLRouter())
            guard
                let viewController = try? factory.build(with: nil)
            else {
                fatalError("Root view controller wasn't built")
            }

            return viewController
        }())
    }
}
