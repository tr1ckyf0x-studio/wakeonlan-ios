//
//  AddHostConfigurator.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

class AddHostConfigurator {
    func configure(viewController: AddHostViewController) {
        let presenter = AddHostPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
    }
}
