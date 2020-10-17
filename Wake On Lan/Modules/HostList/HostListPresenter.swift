//
//  HostListPresenter.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

final class HostListPresenter {
    weak var view: HostListViewInput?
    var router: HostListRouterProtocol?
    var interactor: HostListInteractorInput?
    var tableManager: HostListTableManager?
}

extension HostListPresenter: HostListViewOutput {

    func viewIsReady(_ view: HostListViewInput) {
        interactor?.fetchHosts()
    }
    
    func viewDidPressAddButton(_ view: HostListViewInput) {
        router?.routeToAddHost(with: nil)
    }

}

extension HostListPresenter: HostListInteractorOutput {

    func interactor(_ interactor: HostListInteractorInput, didChangeContent content: [Content]) {
        content.forEach {
            switch $0 {
                case .insert(let indexPath, let object):
                    tableManager?.tableViewModel.insertObject(
                        object, at: indexPath.row, in: indexPath.section)
                case .update(let indexPath, let object):
                    tableManager?.tableViewModel.updateObject(
                        object, at: indexPath.row, in: indexPath.section)
                case .move(old: let oldIndexPath, new: let newIndexPath):
                    tableManager?.tableViewModel.moveObject(
                        from: oldIndexPath.row, to: newIndexPath.row, in: oldIndexPath.section)
                case .delete(let indexPath):
                    tableManager?.tableViewModel.removeObject(
                        at: indexPath.row, in: indexPath.section)
            }
            view?.updateTable(with: $0)
        }
    }

    func interactor(_ interactor: HostListInteractorInput,
                    didFetchHosts hosts: [Host]) {
        let sections: [HostListSectionModel] =
            [hosts.map { HostListSectionItem.host($0) }].map { .mainSection(content: $0) }
        tableManager?.tableViewModel = HostListTableViewModel(sections: sections)
        view?.reloadTable()
    }
    
    func interactor(_ interactor: HostListInteractorInput,
                    didEncounterError error: Error) {
        print(error)
    }
}

extension HostListPresenter: HostListTableManagerDelegate {
    
    func tableManagerDidTapInfoButton(_ tableManager: HostListTableManager, host: Host) {
        router?.routeToAddHost(with: host)
    }
    
    func tableManagerDidTapDeleteButton(_ tableManager: HostListTableManager, host: Host) {
        interactor?.deleteHost(host)
    }
    
    func tableManager(_ tableManager: HostListTableManager,
                      didSelectRowAt indexPath: IndexPath) {
        guard case let .host(host) =
            tableManager.tableViewModel.sections[indexPath.section].items[indexPath.item] else {
                return
        }
        interactor?.wakeHost(host)
    }

}
