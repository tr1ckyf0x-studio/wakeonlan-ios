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

typealias HostListSection = String

typealias HostListItem = HostListSectionItem

typealias HostListSnapshot = NSDiffableDataSourceSnapshot<HostListSection, HostListItem>

protocol HostListViewOutput: AnyObject {
    func viewDidLoad(_ view: HostListViewInput)
    func viewDidPressAddButton(_ view: HostListViewInput)
    func viewDidPressAboutButton(_ view: HostListViewInput)

    func viewDidPressInfoButton(_ view: HostListViewInput, for indexPath: IndexPath)
    func viewDidPressDeleteButton(_ view: HostListViewInput, for indexPath: IndexPath)
    func viewDidPressHostCell(_ view: HostListViewInput, for indexPath: IndexPath)
    func view(
        _ view: HostListViewInput,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    )
}

protocol HostListViewInput: AnyObject {
    func showState(_ state: ViewState)
    func updateContentSnapshot(_ contentSnapshot: HostListSnapshot)
}

protocol HostListInteractorInput: AnyObject {
    func startCacheTracker()
    func wakeHost(_ host: Host)
    func deleteHost(_ host: Host)
    func host(at indexPath: IndexPath) -> Host
    func moveRow(
        at sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    )
}

protocol HostListInteractorOutput: AnyObject {
    func interactor(_ interactor: HostListInteractorInput, didChangeContentSnapshot contentSnapshot: HostListSnapshot)
    func interactor(_ interactor: HostListInteractorInput, didEncounterError error: Error)
}
