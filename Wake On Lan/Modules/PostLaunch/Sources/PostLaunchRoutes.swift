//
//  PostLaunchRoutes.swift
//
//
//  Created by Dmitry Stavitsky on 17.09.2022.
//

import SharedRouter

public protocol PostLaunchRoutes {
    /// Navigates to the list of hosts
    func hostList() -> Route
    /// Navigates to back
    func back(animated: Bool) -> Route
}
