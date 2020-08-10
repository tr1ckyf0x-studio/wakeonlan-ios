//
//  HostListContract.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import CoreData

typealias Content = HostListCacheTracker<Host, HostListInteractor>.Transaction<Host>

protocol HostListViewOutput: class {
    var tableManager: HostListTableManager? { get }
    func viewIsReady(_ view: HostListViewInput)
    func viewDidPressAddButton(_ view: HostListViewInput)
}

protocol HostListViewInput: class {
    func reloadTable()
    func updateTable(with update: Content)
}

protocol HostListInteractorInput: class {
    func fetchHosts()
    func wakeHost(_ host: Host)
}

protocol HostListInteractorOutput: class {
    func interactor(_ interactor: HostListInteractorInput, didChangeContent content: [Content])
    func interactor(_ interactor: HostListInteractorInput, didFetchHosts hosts: [Host])
    func interactor(_ interactor: HostListInteractorInput, didEncounterError error: Error)
}

protocol HostListRouterProtocol: class {
    func routeToAddHost(with host: Host?)
}
