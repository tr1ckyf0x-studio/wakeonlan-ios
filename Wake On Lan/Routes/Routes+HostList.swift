//
//  Routes+HostList.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 11.11.2022.
//  Copyright © 2022 Владислав Лисянский. All rights reserved.
//

import AboutScreen
import AddHost
import CoreDataService
import SharedRouter

extension WOLRouter {
    /// Navigates to `AddHost` screen.
    public func openAddHost(with host: Host?) -> Route {
        Route {
            try? defaultRouter.navigate(
                to: defaultStepRoutePushAction(factory: AddHostFactory(router: self)),
                with: host,
                animated: true,
                completion: $0
            )
        }
    }

    /// Navigates to `About` screen.
    public func openAbout() -> Route {
        Route {
            try? defaultRouter.navigate(
                to: defaultStepRoutePushAction(factory: AboutScreenFactory(router: self)),
                with: nil,
                animated: true,
                completion: $0
            )
        }
    }
}
