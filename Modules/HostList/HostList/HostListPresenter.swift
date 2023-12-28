//
//  HostListPresenter.swift
//  Wake On Lan
//
//  Created by Vladislav Lisianskii on 27.04.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import CocoaLumberjack
import CoreDataService
import SharedRouter

final class HostListPresenter: Navigates {
    // MARK: - Properties

    weak var view: HostListViewInput?
    var router: HostListRoutes?
    var interactor: HostListInteractorInput?
}

// MARK: - HostListViewOutput

extension HostListPresenter: HostListViewOutput {
    func viewDidLoad(_ view: HostListViewInput) {
        view.showState(.default)
        interactor?.startCacheTracker()
    }

    func viewDidPressAddButton(_ view: HostListViewInput) {
        navigate(to: router?.openAddHost(with: nil))
    }

    func viewDidPressAboutButton(_ view: HostListViewInput) {
        navigate(to: router?.openAbout())
    }

    func viewDidPressInfoButton(_ view: HostListViewInput, for indexPath: IndexPath) {
        guard let host = interactor?.fetchHost(at: indexPath) else { return }
        navigate(to: router?.openAddHost(with: host))
    }

    func viewDidPressDeleteButton(_ view: HostListViewInput, for indexPath: IndexPath) {
        guard let host = interactor?.fetchHost(at: indexPath) else { return }
        interactor?.deleteHost(host)
    }

    func viewDidPressHostCell(_ view: HostListViewInput, for indexPath: IndexPath) {
        guard let host = interactor?.fetchHost(at: indexPath) else { return }
        interactor?.wakeHost(host)
    }

    func view(
        _ view: HostListViewInput,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        interactor?.moveRow(from: sourceIndexPath, to: destinationIndexPath)
    }
}

// MARK: - HostListInteractorOutput

extension HostListPresenter: HostListInteractorOutput {
    func interactor(_ interactor: HostListInteractorInput, didChangeContentSnapshot contentSnapshot: HostListSnapshot) {
        view?.updateContentSnapshot(contentSnapshot)
        if contentSnapshot.numberOfItems > .zero {
            view?.showState(.default)
        } else {
            view?.showState(.empty)
        }
    }

    func interactor(
        _ interactor: HostListInteractorInput,
        didEncounterError error: Error
    ) {
        DDLogError("HostListInteractor encountered error: \(error)")
    }
}
