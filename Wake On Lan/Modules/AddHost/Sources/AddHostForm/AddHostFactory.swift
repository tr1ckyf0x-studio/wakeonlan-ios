//
//  AddHostConfigurator.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
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


//    public func configure(viewController: AddHostViewController, with host: Host? = nil ) {
//        let presenter = AddHostPresenter<AddHostRouter>(addHostForm: AddHostForm(host: host))
//        let interactor = AddHostInteractor()
//        let router = AddHostRouter()
//
//        router.viewController = viewController
//        presenter.router = router
//
//        interactor.presenter = presenter
//        presenter.interactor = interactor
//
//        viewController.presenter = presenter
//        presenter.view = viewController
//    }

}

//func routeToAddHost(with host: Host? = nil) {
//    let addHostViewController = AddHostViewController()
//    let addHostConfigurator = AddHostFactory()
//    addHostConfigurator.configure(viewController: addHostViewController, with: host)
//    viewController?.navigationController?.pushViewController(
//        addHostViewController,
//        animated: true
//    )
//}

extension AddHostFactory: Factory {
    public func build(with context: Context) throws -> AddHostViewController {
        let viewController = AddHostViewController()

        let presenter = AddHostPresenter(addHostForm: AddHostForm(host: context))
        presenter.router = router

        let interactor = AddHostInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor

        viewController.presenter = presenter
        presenter.view = viewController

        return viewController
    }
}
