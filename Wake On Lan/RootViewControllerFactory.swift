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
        let hostList = HostListFactory(router: WOLRouter()).build(with: nil)

        return WOLNavigationController(rootViewController: hostList)
    }
}
