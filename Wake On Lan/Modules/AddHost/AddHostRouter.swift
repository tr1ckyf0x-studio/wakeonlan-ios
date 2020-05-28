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
        let chooseViewController = ChooseIconViewController()
        guard let viewController = self.viewController else { return }
        viewController.present(chooseViewController, animated: true)
    }

}
