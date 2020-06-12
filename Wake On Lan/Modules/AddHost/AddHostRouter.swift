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

    func routeToChooseIcon(items: [FormItem]) {
        // TODO: Needs to be refactored(viewConroller cast)
        guard let addHostViewController = viewController as? AddHostViewController else { return }
        let chooseIconViewController = ChooseIconViewController()
        chooseIconViewController.modalPresentationStyle = .overCurrentContext
        let configurator = ChooseIconConfigurator()
        configurator.configure(viewController: chooseIconViewController,
                               items: items,
                               moduleDelegate: addHostViewController.presenter)
        viewController?.present(chooseIconViewController, animated: true)
    }

}
