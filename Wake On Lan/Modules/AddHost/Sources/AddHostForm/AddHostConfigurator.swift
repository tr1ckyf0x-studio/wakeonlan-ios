//
//  AddHostConfigurator.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CoreDataService
import Foundation

public final class AddHostConfigurator {

    public init() { }

    public func configure(viewController: AddHostViewController, with host: Host? = nil ) {
        let presenter = AddHostPresenter<AddHostRouter>(addHostForm: AddHostForm(host: host))
        let interactor = AddHostInteractor(coreDataService: CoreDataService.shared)
        let router = AddHostRouter()

        router.viewController = viewController
        presenter.router = router

        interactor.presenter = presenter
        presenter.interactor = interactor

        viewController.presenter = presenter
        presenter.view = viewController
    }

}
