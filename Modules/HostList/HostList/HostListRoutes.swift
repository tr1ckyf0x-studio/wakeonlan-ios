//
//  HostListRoutes.swift
//  Wake On Lan
//
//  Created by Vladislav Lisianskii on 27.04.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import CoreDataService
import SharedRouter

public protocol HostListRoutes {
    /// Navigates to `AddHost` screen
    func openAddHost(with host: Host?) -> Route
    /// Navigates to `About` screen
    func openAbout() -> Route
}
