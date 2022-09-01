//
//  ChooseIconRouter.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import UIKit

final class ChooseIconRouter: ChooseIconRouterProtocol {
    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func dismiss(animated: Bool) {
        viewController?.dismiss(animated: animated)
    }

}
