//
//  HostListConfigurator.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CoreDataService
import Foundation
import WakeOnLanService

public final class HostListConfigurator {

    public init() { }

    public func configure(viewController: HostListViewController) {
        let presenter = HostListPresenter()
        let interactor = HostListInteractor(
            coreDataService: CoreDataService.shared,
            wakeOnLanService: WakeOnLanService.shared
        )
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
