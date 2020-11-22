//
//  HostListConfigurator.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

final class HostListConfigurator {

    func configure(viewController: HostListViewController) {
        let presenter = HostListPresenter()
        let interactor = HostListInteractor()
        let router = HostListRouter()
        let tableManager = HostListTableManager()

        presenter.tableManager = tableManager
        tableManager.delegate = presenter

        presenter.interactor = interactor
        interactor.presenter = presenter

        viewController.presenter = presenter
        presenter.view = viewController

        presenter.router = router
        router.viewController = viewController
    }

}
