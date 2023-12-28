//
//  AboutScreenRoutes.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 24.04.2021.
//  Copyright © 2021 Vladislav Lisianskii. All rights reserved.
//

import SharedRouter

public protocol AboutScreenRoutes {
    /// Navigates back
    func backOrDismiss(animated: Bool) -> Route

    /// Navigates to `Donate` screen
    func openDonate() -> Route
}
