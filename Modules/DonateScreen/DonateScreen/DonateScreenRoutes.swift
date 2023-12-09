//
//  DonateScreenRoutes.swift
//  
//
//  Created by Vladislav Lisianskii on 14.04.2023.
//

import SharedRouter

public protocol DonateScreenRoutes {
    /// Navigates to back
    func backOrDismiss(animated: Bool) -> Route
}
