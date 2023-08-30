//
//  DonateScreenFactory.swift
//  
//
//  Created by Vladislav Lisianskii on 14.04.2023.
//

import IAPManager
import RouteComposer
import UIKit

public struct DonateScreenFactory {
    public typealias Context = Void?

    // MARK: - Properties

    private let router: DonateScreenRoutes

    // MARK: - Init

    public init(router: DonateScreenRoutes) {
        self.router = router
    }
}

// MARK: - Factory

extension DonateScreenFactory: Factory {
    @MainActor
    public func build(with context: Context) throws -> DonateScreenViewController {
        let viewController = DonateScreenViewController()
        let presenter = DonateScreenPresenter()
        let interactor = DonateScreenInteractor(iAPManager: IAPManager.shared)

        viewController.presenter = presenter

        presenter.interactor = interactor
        presenter.router = router
        presenter.view = viewController

        interactor.presenter = presenter

        return viewController
    }
}
