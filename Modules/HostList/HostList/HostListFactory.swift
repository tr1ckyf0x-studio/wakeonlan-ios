//
//  HostListFactory.swift
//  Wake On Lan
//
//  Created by Vladislav Lisianskii on 27.04.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import CoreDataService
import RouteComposer
import SharedRouter
import WakeOnLanService

public struct HostListFactory {
    public typealias Context = Void?

    // MARK: - Properties

    private let router: HostListRoutes

    // MARK: - Init

    public init(router: HostListRoutes) {
        self.router = router
    }
}

// MARK: - Factory

extension HostListFactory: Factory {
    public func build(with context: Context) throws -> HostListViewController {
        let viewController = HostListViewController()
        let presenter = HostListPresenter()
        let coreDataService = CoreDataService.shared
        let cacheTracker = HostListCacheTracker(
            with: Host.sortedFetchRequest,
            context: coreDataService.mainContext,
            mapper: HostListSnapshotMapper()
        )
        let interactor = HostListInteractor(
            coreDataService: coreDataService,
            wakeOnLanService: WakeOnLanService.shared,
            cacheTracker: cacheTracker,
            hostCrudWorker: HostCRUDWorker(),
            hostMoveWorker: MoveHostWorker()
        )

        cacheTracker.delegate = interactor

        presenter.interactor = interactor
        interactor.presenter = presenter

        viewController.presenter = presenter
        presenter.view = viewController

        presenter.router = router

        return viewController
    }
}
