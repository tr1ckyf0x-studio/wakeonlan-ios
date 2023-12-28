//
//  Routes+PostLaunch.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 11.11.2022.
//  Copyright © 2022 Vladislav Lisianskii. All rights reserved.
//

import HostList
import SharedRouter

extension WOLRouter {
    /// Navigates to `HostList` screen.
    public func hostList() -> Route {
        Route {
            try? defaultRouter.navigate(
                to: defaultStepRoutePushAsRootAction(factory: HostListFactory(router: self)),
                with: nil,
                animated: false,
                completion: $0
            )
        }
    }
}
