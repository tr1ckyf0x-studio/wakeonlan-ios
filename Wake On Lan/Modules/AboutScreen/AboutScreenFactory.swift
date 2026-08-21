//
//  AboutScreenConfigurator.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 24.04.2021.
//  Copyright © 2021 Vladislav Lisianskii. All rights reserved.
//

import RouteComposer

@MainActor
public final class AboutScreenFactory {
    public typealias Context = Void?

    private let router: AboutScreenRoutes

    // MARK: - Init

    public init(router: AboutScreenRoutes) {
        self.router = router
    }
}

// MARK: - Factory

extension AboutScreenFactory: Factory {
    public func build(with context: Context) -> AboutScreenViewController {
        let viewController = AboutScreenViewController()
        let presenter = AboutScreenPresenter()
        let interactor = AboutScreenInteractor()

        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        viewController.presenter = presenter
        presenter.view = viewController

        return viewController
    }
}
