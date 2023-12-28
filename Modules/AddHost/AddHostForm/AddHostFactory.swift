//
//  AddHostConfigurator.swift
//  Wake On Lan
//
//  Created by Vladislav Lisianskii on 27.04.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import CoreDataService
import RouteComposer

public final class AddHostFactory {
    public typealias ViewController = AddHostViewController

    public typealias Context = Host?

    // MARK: - Properties

    private let router: AddHostRoutes

    // MARK: - Init

    public init(router: AddHostRoutes) {
        self.router = router
    }
}

extension AddHostFactory: Factory {
    public func build(with context: Context) throws -> AddHostViewController {
        let viewController = AddHostViewController()

        let presenter = AddHostPresenter(addHostForm: AddHostForm(host: context))
        presenter.router = router

        let coreDataService = CoreDataService.shared
        let interactor = AddHostInteractor(
            coreDataService: coreDataService,
            hostCrudWorker: HostCRUDWorker(coreDataService: coreDataService)
        )
        interactor.presenter = presenter
        presenter.interactor = interactor

        viewController.presenter = presenter
        presenter.view = viewController

        return viewController
    }
}
