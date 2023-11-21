//
//  HostListInteractor.swift
//  Wake on LAN
//
//  Created by Владислав Лисянский on 21.05.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CocoaLumberjack
import CoreDataService
import Foundation
import WakeOnLanService

final class HostListInteractor: HostListInteractorInput {

    private let coreDataService: CoreDataServiceProtocol
    private let wakeOnLanService: WakeOnLanService
    private let cacheTracker: TracksHostListCache
    private let hostCrudWorker: PerformsHostCRUD

    weak var presenter: HostListInteractorOutput?

    init(
        coreDataService: CoreDataServiceProtocol,
        wakeOnLanService: WakeOnLanService,
        cacheTracker: TracksHostListCache,
        hostCrudWorker: PerformsHostCRUD
    ) {
        self.coreDataService = coreDataService
        self.wakeOnLanService = wakeOnLanService
        self.cacheTracker = cacheTracker
        self.hostCrudWorker = hostCrudWorker
    }

    func startCacheTracker() {
        cacheTracker.start()
    }

    func deleteHost(_ host: Host) {
        guard let context = host.managedObjectContext else { return }
        hostCrudWorker.delete(host: host, context: context)
    }

    func wakeHost(_ host: Host) {
        Task {
            do {
                try await wakeOnLanService.sendMagicPacket(to: host)
                DDLogDebug("Magic packet was sent")
            } catch {
                presenter?.interactor(self, didEncounterError: error)
                DDLogError("Magic packet was not sent due to error: \(error)")
            }
        }
    }

    func host(at indexPath: IndexPath) -> Host {
        cacheTracker.hostAtIndexPath(indexPath)
    }

    func moveRow(at sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let hosts = cacheTracker.fetchedObjects else { return }
        hostCrudWorker.move(
            from: sourceIndexPath,
            to: destinationIndexPath,
            in: hosts,
            context: cacheTracker.context
        )
    }
}

// MARK: - HostListCacheTrackerDelegate

extension HostListInteractor: HostListCacheTrackerDelegate {

    func cacheTracker(
        _ tracker: TracksHostListCache,
        didChangeContentSnapshot contentSnapshot: HostListSnapshot
    ) {
        presenter?.interactor(self, didChangeContentSnapshot: contentSnapshot)
    }

}
