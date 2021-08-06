//
//  HostListPresenter.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import CocoaLumberjackSwift
import CoreDataService

final class HostListPresenter {

    // MARK: - Properties

    weak var view: HostListViewInput?
    var router: HostListRouterProtocol?
    var interactor: HostListInteractorInput?
    var tableManager: HostListTableManager = .init()

}

// MARK: - HostListViewOutput

extension HostListPresenter: HostListViewOutput {

    func viewDidLoad(_ view: HostListViewInput) {
        view.contentView.showState(.default)
        interactor?.fetchHosts()
    }

    func viewDidPressAddButton(_ view: HostListViewInput) {
        router?.routeToAddHost(with: nil)
    }

    func viewDidPressAboutButton(_ view: HostListViewInput) {
        router?.routeToAbout()
    }
}

// MARK: - HostListInteractorOutput

extension HostListPresenter: HostListInteractorOutput {

    func interactor(_ interactor: HostListInteractorInput, didChangeContent content: [Content]) {
        tableManager.update(with: content)
        content.forEach { view?.updateTable(with: $0) }
        if tableManager.itemsCount > .zero {
            view?.contentView.showState(.default)
        } else {
            view?.contentView.showState(.empty)
        }
    }

    func interactor(_ interactor: HostListInteractorInput, didFetchHosts hosts: [Host]) {
        let sections: [HostListSectionModel] =
            [hosts.map { HostListSectionItem.host($0) }].map { .mainSection(content: $0) }
        tableManager.dataStore = HostListDataStore(sections: sections)
        view?.reloadTable()
        if hosts.isEmpty { view?.contentView.showState(.empty) }
    }

    func interactor(
        _ interactor: HostListInteractorInput,
        didEncounterError error: Error
    ) {
        DDLogError("HostListInteractor encountered error: \(error)")
    }
}

// MARK: - HostListTableManagerDelegate

extension HostListPresenter: HostListTableManagerDelegate {

    func tableManagerDidTapHostCell(_ tableManager: HostListTableManager, host: Host) {
        interactor?.wakeHost(host)
    }

    func tableManagerDidTapInfoButton(_ tableManager: HostListTableManager, host: Host) {
        router?.routeToAddHost(with: host)
    }

    func tableManagerDidTapDeleteButton(_ tableManager: HostListTableManager, host: Host) {
        interactor?.deleteHost(host)
    }

}
