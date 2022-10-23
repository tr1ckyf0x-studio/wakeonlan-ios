//
//  ChooseIconConfigurator.swift
//  Wake on LAN
//
//  Created by Dmitry Stavitsky on 28.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import RouteComposer
import UIKit
import WOLUIComponents

public struct ChooseIconFactory: Factory {
    public typealias ViewController = ChooseIconViewController

    public typealias Context = ChooseIconModuleOutput

    // MARK: - Properties

    private let router: ChooseIconRoutes

    // MARK: - Init

    public init(router: ChooseIconRoutes) {
        self.router = router
    }

    public func build(with context: Context) throws -> ChooseIconViewController {
        let presenter = ChooseIconPresenter()
        presenter.moduleDelegate = context
        let viewController = ChooseIconViewController()
        presenter.router = router
        presenter.view = viewController
        viewController.presenter = presenter

        return viewController
    }
}
