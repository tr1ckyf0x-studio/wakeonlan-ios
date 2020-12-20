//
//  AddHostRouter.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 23.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

class AddHostRouter: AddHostRouterProtocol {
    var viewController: UIViewController?

    func routeToChooseIcon() {
        // TODO: Needs to be refactored(viewConroller cast)
        guard let addHostViewController = viewController as? AddHostViewController else { return }
        let chooseIconViewController = ChooseIconViewController()
        let configurator = ChooseIconConfigurator()
        configurator.configure(
            viewController: chooseIconViewController,
            moduleDelegate: addHostViewController.presenter
        )
        viewController?.present(chooseIconViewController, animated: true)
    }

}
