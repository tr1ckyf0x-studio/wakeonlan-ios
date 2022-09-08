//
//  HostListContract.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//
import CoreDataService
import WOLUIComponents

typealias Content = HostListCacheTracker<Host, HostListInteractor>.Transaction<Host>

// sourcery: AutoMockable
protocol HostListTableManagerProtocol: AnyObject {
    var dataStore: HostListDataStore { get set }
    var itemsCount: Int { get }

    func update(with content: [Content])
}

protocol HostListViewOutput: AnyObject {
    func viewDidLoad(_ view: HostListViewInput)
    func viewDidPressAddButton(_ view: HostListViewInput)
    func viewDidPressAboutButton(_ view: HostListViewInput)
}

protocol HostListViewInput: AnyObject {
    var contentView: StateableView { get }

    func reloadTable()
    func updateTable(with update: Content)
}

protocol HostListInteractorInput: AnyObject {
    func fetchHosts()
    func wakeHost(_ host: Host)
    func deleteHost(_ host: Host)
}

protocol HostListInteractorOutput: AnyObject {
    func interactor(_ interactor: HostListInteractorInput, didChangeContent content: [Content])
    func interactor(_ interactor: HostListInteractorInput, didFetchHosts hosts: [Host])
    func interactor(_ interactor: HostListInteractorInput, didEncounterError error: Error)
}

protocol HostListRouterProtocol: AnyObject {
    func routeToAddHost(with host: Host?)
    func routeToAbout()
}
