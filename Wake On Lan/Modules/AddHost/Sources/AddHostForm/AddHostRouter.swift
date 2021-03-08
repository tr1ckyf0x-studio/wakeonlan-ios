//
//  AddHostRouter.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 23.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit
import WOLUIComponents

final class AddHostRouter: AddHostRouterProtocol {
    var viewController: AddHostViewController?

    func routeToChooseIcon() {
        let chooseIconViewController = ChooseIconViewController()
        let configurator = ChooseIconConfigurator()
        configurator.configure(
            viewController: chooseIconViewController,
            moduleDelegate: viewController?.presenter
        )
        chooseIconViewController.modalPresentationStyle = .custom
        let transitioningDelegate = SelfSizingBottomSheetModalTransitionDelegate()
        chooseIconViewController.transitioningDelegate = transitioningDelegate
        viewController?.present(chooseIconViewController, animated: true)
    }

}
