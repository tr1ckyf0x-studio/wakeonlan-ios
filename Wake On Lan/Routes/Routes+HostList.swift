//
//  Routes+HostList.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 11.11.2022.
//  Copyright © 2022 Vladislav Lisianskii. All rights reserved.
//

import CoreDataService

@MainActor
extension WOLRouter {
    /// Navigates to `AddHost` screen.
    public func openAddHost(with host: Host?) -> Route {
        Route { completion in
            try? defaultRouter.navigate(
                to: defaultStepRoutePushAction(factory: AddHostFactory(router: self)),
                with: host,
                animated: true,
                completion: completion
            )
        }
    }

    /// Navigates to `About` screen.
    public func openAbout() -> Route {
        Route { completion in
            try? defaultRouter.navigate(
                to: defaultStepRoutePushAction(factory: AboutScreenFactory(router: self)),
                with: nil,
                animated: true,
                completion: completion
            )
        }
    }
}
