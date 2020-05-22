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
        let interactor = AddHostInteractor()
        let router = AddHostRouter()
        
        router.viewController = viewController
        presenter.router = router
        
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        viewController.presenter = presenter
        presenter.view = viewController
    }
}
