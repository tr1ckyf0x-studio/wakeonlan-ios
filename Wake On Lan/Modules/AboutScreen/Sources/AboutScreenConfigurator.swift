//
//  AboutScreenConfigurator.swift
//  AboutScreen
//
//  Created by Vladislav Lisianskii on 24.04.2021.
//  Copyright © 2021 Владислав Лисянский. All rights reserved.
//

import Foundation

public final class AboutScreenConfigurator {

    // MARK: - Init

    public init() { }

    public func configure(viewController: AboutScreenViewController) {
        let presenter = AboutScreenPresenter()
        let interactor = AboutScreenInteractor()
        let router = AboutScreenRouter()

        presenter.interactor = interactor
        interactor.presenter = presenter

        viewController.presenter = presenter
        presenter.view = viewController

        presenter.router = router
        router.viewController = viewController
    }
}
