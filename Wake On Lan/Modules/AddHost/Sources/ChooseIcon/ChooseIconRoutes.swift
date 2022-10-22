//
//  ChooseIconRoutes.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import SharedRouter

public protocol ChooseIconRoutes {
    /// Navigates to back
    func backOrDismiss(animated: Bool) -> Route
}
