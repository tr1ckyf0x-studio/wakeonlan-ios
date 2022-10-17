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

//final class AddHostRoutes: AddHostRouterProtocol {
//    var viewController: AddHostViewController?
//    func routeToChooseIcon() {
//        let chooseIconViewController = ChooseIconViewController()
//        let configurator = ChooseIconConfigurator()
//        configurator.configure(viewController: chooseIconViewController, moduleDelegate: viewController?.presenter)
//        chooseIconViewController.modalPresentationStyle = .custom
//        let transitioningDelegate = SelfSizingBottomSheetModalTransitionDelegate()
//        chooseIconViewController.transitioningDelegate = transitioningDelegate
//        viewController?.present(chooseIconViewController, animated: true)
//    }
//}

public protocol AddHostRoutes {
    typealias TransitioningDelegate = UIViewControllerTransitioningDelegate

    /// Navigates to the `Choose Icon` screen
    func openChooseIcon(moduleDelegate: ChooseIconModuleOutput?, transitioningDelegate: TransitioningDelegate?) -> Route

    /// Navigates to back
    func backOrDismiss(animated: Bool) -> Route
}
