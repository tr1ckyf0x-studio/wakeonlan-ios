//
//  AddHostRouter.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 23.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import SharedRouter
import UIKit
import WOLUIComponents

public protocol AddHostRoutes {
    typealias TransitioningDelegate = UIViewControllerTransitioningDelegate
    /// Navigates to the `Choose Icon` screen
    func openChooseIcon(with context: ChooseIconFactory.Context) -> Route
    /// Navigates to back
    func backOrDismiss(animated: Bool) -> Route
}
