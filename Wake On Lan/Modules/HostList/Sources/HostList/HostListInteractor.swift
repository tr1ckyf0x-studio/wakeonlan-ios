//
//  HostListInteractor.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 21.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CocoaLumberjackSwift
import CoreDataService
import Foundation
import WakeOnLanService

final class HostListInteractor: HostListInteractorInput {
    private let coreDataService: CoreDataServiceProtocol
    private let wakeOnLanService: WakeOnLanService
    private let cacheTracker: TracksHostListCache

    weak var presenter: HostListInteractorOutput?

    init(
        coreDataService: CoreDataServiceProtocol,
        wakeOnLanService: WakeOnLanService,
        cacheTracker: TracksHostListCache
    ) {
        self.coreDataService = coreDataService
        self.wakeOnLanService = wakeOnLanService
        self.cacheTracker = cacheTracker
    }

    func startCacheTracker() {
        cacheTracker.start()
    }

    func deleteHost(_ host: Host) {
        guard let context = host.managedObjectContext else { return }
        context.perform { [weak self] in
            context.delete(host)
            self?.coreDataService.saveContext(context, completionHandler: nil)
            DDLogDebug("Host deleted")
        }
    }

    func wakeHost(_ host: Host) {
        do {
            try wakeOnLanService.sendMagicPacket(to: host)
            DDLogDebug("Magic packet was sent")
        } catch {
            presenter?.interactor(self, didEncounterError: error)
            DDLogError("Magic packet was not sent due to error: \(error)")
        }
    }

    func host(at indexPath: IndexPath) -> Host {
        cacheTracker.hostAtIndexPath(indexPath)
    }

    func changeHostsOrder() {
        cacheTracker.nextSortDescriptor()
        let sortDescriptors = cacheTracker.sortDescriptors()
        guard let currentSortState = sortStateFromSortDescriptors(sortDescriptors) else {
            return
        }
        presenter?.interactor(self, didChangeSortState: currentSortState)
    }

    func getCurrentSortState() {
        let sortDescriptors = cacheTracker.sortDescriptors()
        guard let state = sortStateFromSortDescriptors(sortDescriptors) else {
            return
        }
        presenter?.interactor(self, didGetCurrentSortState: state)
    }

}

// MARK: - HostListCacheTrackerDelegate

extension HostListInteractor: HostListCacheTrackerDelegate {
    func cacheTracker(
        _ tracker: TracksHostListCache,
        didChangeContentSnapshot contentSnapshot: ContentSnapshot
    ) {
        presenter?.interactor(self, didChangeContentSnapshot: contentSnapshot)
    }
}

// MARK: - Private Methods
extension HostListInteractor {
    private func sortStateFromSortDescriptors(_ descriptors: [NSSortDescriptor]?) -> SortState? {
        guard let selectedSortDescriptor = descriptors else {
            return nil
        }
        switch selectedSortDescriptor {

        case Host.defaultSortDescriptors:
            return .dateAdded

        case Host.alphabeticAscendingSortDescriptors:
            return .acsendingAlphabetic

        case Host.alphabeticDescendingSortDescriptors:
            return .descendingAlphabetic

        case Host.itemIconNameSortDescriptors:
            return .deviceIconName

        default:
            DDLogError("Unhandled sort descriptor")
            return .dateAdded
        }
    }
}
