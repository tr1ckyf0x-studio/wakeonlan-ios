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
    func interactor(_ interactor: HostListInteractorInput, didUpdateHosts hosts: [Host]) {
        let mainSectionItems = hosts.map { HostListSectionItem.host($0) }
        let mainSection = HostListSectionModel.mainSection(content: mainSectionItems, header: nil, footer: nil)
        let sections = [mainSection]
        tableManager?.sections = sections
        view?.reloadTable()
    }
    
    func interactor(_ interactor: HostListInteractorInput, didEncounterError error: Error) {
        print(error)
    }

}

extension HostListPresenter: HostListTableManagerDelegate {
    
    func tableManagerDidTapInfoButton(_ tableManager: HostListTableManager, host: Host) {
        router?.routeToAddHost(with: host)
    }
    
    func tableManager(_ tableManager: HostListTableManager, didSelectRowAt indexPath: IndexPath) {
        guard case let .host(host) =
            tableManager.sections[indexPath.section].items[indexPath.item] else { return }
        interactor?.wakeHost(host)
    }

}

extension HostListPresenter: HostListCacheTrackerDelegate {
    
    func cacheTracker(_ tracker: CacheTracker,
                      didChangeContent content: [HostListCacheTracker<Host, HostListPresenter>.Transaction<Host>]) {
        content.forEach {
            switch $0 {
                case .insert(let indexPath):
                return
                case .update(let indexPath, let object):
                return
                case .move(old: let oldIndexPath, new: let newIndexPath):
                return
                case .delete(let indexPath):
                return
            }
        }
        
    }
    
    typealias Object = Host
    
    
}
