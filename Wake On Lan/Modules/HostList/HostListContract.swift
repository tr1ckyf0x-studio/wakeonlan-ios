//
//  HostListContract.swift
//  Wake On Lan
//
//  Created by Vladislav Lisianskii on 27.04.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import CoreDataService
import UIKit

typealias HostListSection = String

typealias HostListItem = HostListSectionItem

typealias HostListSnapshot = NSDiffableDataSourceSnapshot<HostListSection, HostListItem>

@MainActor
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
    func viewDidPressDonateButton(_ view: HostListViewInput)
}

/// Outcome of an attempt to wake a host, as shown on the host's card.
enum HostListNotification {
    case packetSent
    case failure
}

@MainActor
protocol HostListViewInput: AnyObject {
    func showState(_ state: ViewState)
    func updateContentSnapshot(_ contentSnapshot: HostListSnapshot)
    func showNotification(_ notification: HostListNotification, at indexPath: IndexPath)
}

@MainActor
protocol HostListInteractorInput: AnyObject {
    func startCacheTracker()
    func wakeHost(_ host: Host, at indexPath: IndexPath)
    func deleteHost(_ host: Host)
    func fetchHost(at indexPath: IndexPath) -> Host
    func moveRow(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}

@MainActor
protocol HostListInteractorOutput: AnyObject {
    func interactor(_ interactor: HostListInteractorInput, didChangeContentSnapshot contentSnapshot: HostListSnapshot)
    func interactor(_ interactor: HostListInteractorInput, didWakeHostAt indexPath: IndexPath)
    func interactor(
        _ interactor: HostListInteractorInput,
        didFailToWakeHostAt indexPath: IndexPath,
        error: Error
    )
}
