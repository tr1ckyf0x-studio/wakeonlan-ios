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
    private let cacheTracker: any CacheTracker<Host>

    weak var presenter: HostListInteractorOutput?

    init(
        coreDataService: CoreDataServiceProtocol,
        wakeOnLanService: WakeOnLanService,
        cacheTracker: any CacheTracker<Host>
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
        cacheTracker.objectAtIndexPath(indexPath)
    }

}

// MARK: - HostListCacheTrackerDelegate

extension HostListInteractor: CacheTrackerDelegate {

    typealias SnapshotSectionIdentifier = String

    typealias SnapshotItemIdentifier = HostListSectionItem

    func cacheTracker(
        _ tracker: any CacheTracker,
        didChangeContentSnapshot contentSnapshot: ContentSnapshot
    ) {
        presenter?.interactor(self, didChangeContentSnapshot: contentSnapshot)
    }

}
