//
//  AddHostRouter.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 23.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import WOLUIComponents
import SharedRouter

public protocol AddHostRoutes {
    typealias TransitioningDelegate = UIViewControllerTransitioningDelegate
    /// Navigates to the `Choose Icon` screen
    func openChooseIcon(with context: ChooseIconFactory.Context) -> Route
    /// Navigates to back
    func backOrDismiss(animated: Bool) -> Route
}
