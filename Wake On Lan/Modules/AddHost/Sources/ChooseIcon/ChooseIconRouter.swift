//
//  ChooseIconRouter.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

class ChooseIconRouter: ChooseIconRouterProtocol {
    var viewController: ChooseIconViewInput?

    init(viewController: ChooseIconViewInput) {
        self.viewController = viewController
    }

}
