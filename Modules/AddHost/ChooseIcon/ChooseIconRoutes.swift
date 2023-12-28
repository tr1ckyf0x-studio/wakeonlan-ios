//
//  ChooseIconRoutes.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import SharedRouter
import UIKit

public protocol ChooseIconRoutes {
    /// Navigates to back
    func backOrDismiss(animated: Bool) -> Route
}
