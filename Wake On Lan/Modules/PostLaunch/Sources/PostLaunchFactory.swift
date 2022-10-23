//
//  PostLaunchFactory.swift
//
//
//  Created by Dmitry Stavitsky on 17.09.2022.
//

import CoreDataService
import Foundation
import RouteComposer
import SharedRouter

@MainActor
public struct PostLaunchFactory {
    public typealias Context = Void?

    // MARK: - Properties

    private let router: PostLaunchRoutes

    // MARK: - Init

    public init(router: PostLaunchRoutes) {
        self.router = router
    }
}

// MARK: - Factory

extension PostLaunchFactory: Factory {
    public func build(with context: Context) throws -> PostLaunchViewController {
        let viewController = PostLaunchViewController()
        let presenter = PostLaunchPresenter()

        let coreDataMigration = CoreDataAppToSharedGroupMigration(
            coreDataService: CoreDataService.shared,
            fileManager: FileManager.default
        )

        let interactor = PostLaunchInteractor(
            coreDataMigration: coreDataMigration,
            coreDataService: CoreDataService.shared
        )

        viewController.presenter = presenter

        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter

        return viewController
    }
}
