//
//  ChooseIconConfigurator.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

class ChooseIconConfigurator {

    func configure(viewController: ChooseIconViewInput,
                   moduleDelegate: ChooseIconModuleOutput?) {
        let presenter = ChooseIconPresenter()
        presenter.moduleDelegate = moduleDelegate
        let router = ChooseIconRouter(viewController: viewController)

        presenter.router = router
        presenter.view = viewController

        viewController.presenter = presenter
    }

}
