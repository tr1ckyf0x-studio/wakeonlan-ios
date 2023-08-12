//
//  HostListContract.swift
//  Wake On Lan
//
//  Created by Владислав Лисянский on 27.04.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CoreDataService
import UIKit
import WOLUIComponents

typealias ContentSnapshot = NSDiffableDataSourceSnapshot<String, HostListSectionItem>

protocol HostListViewOutput: AnyObject {
    func viewDidLoad(_ view: HostListViewInput)
    func viewDidPressAddButton(_ view: HostListViewInput)
    func viewDidPressAboutButton(_ view: HostListViewInput)
    func viewDidPressSortButton(_ view: HostListViewInput)

    func viewDidPressInfoButton(_ view: HostListViewInput, for indexPath: IndexPath)
    func viewDidPressDeleteButton(_ view: HostListViewInput, for indexPath: IndexPath)
    func viewDidPressHostCell(_ view: HostListViewInput, for indexPath: IndexPath)
}

protocol HostListViewInput: AnyObject {
    func showState(_ state: ViewState)
    func updateContentSnapshot(_ contentSnapshot: ContentSnapshot)
    func updateSortButtonState(_ state: SortState)
}

protocol HostListInteractorInput: AnyObject {
    func startCacheTracker()
    func wakeHost(_ host: Host)
    func deleteHost(_ host: Host)
    func host(at indexPath: IndexPath) -> Host
    func changeHostsOrder()
    func getCurrentSortState()
}

protocol HostListInteractorOutput: AnyObject {
    func interactor(_ interactor: HostListInteractorInput, didChangeContentSnapshot contentSnapshot: ContentSnapshot)
    func interactor(_ interactor: HostListInteractorInput, didEncounterError error: Error)
    func interactor(_ interactor: HostListInteractorInput, didChangeSortState sortState: SortState)
    func interactor(_ interactor: HostListInteractorInput, didGetCurrentSortState sortState: SortState)
}
