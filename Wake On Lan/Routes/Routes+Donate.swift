//
//  Routes+Donate.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 14.04.2023.
//  Copyright © 2023 Vladislav Lisianskii. All rights reserved.
//

import DonateScreen
import SharedRouter

extension WOLRouter {
    /// Navigates to `Donate` screen.
    public func openDonate() -> Route {
        Route {
            try? defaultRouter.navigate(
                to: defaultStepRoutePushAction(factory: DonateScreenFactory(router: self)),
                with: nil,
                animated: true,
                completion: $0
            )
        }
    }
}
