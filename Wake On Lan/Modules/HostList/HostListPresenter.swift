//
//  HostListPresenter.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation

class HostListPresenter {
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
        router?.routeToAddHost()
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
    func tableManager(_ tableManager: HostListTableManager, didSelectRowAt indexPath: IndexPath) {
        guard case let .host(host) = tableManager.sections[indexPath.section].items[indexPath.item] else { return }
        
        interactor?.wakeHost(host)
    }
}
