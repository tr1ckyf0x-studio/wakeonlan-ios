//
//  HostListInteractor.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 21.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import CocoaLumberjackSwift
import CoreDataService
import PersistenceCore
import WakeOnLanService
import WOLSharedProtocolsAndModels

final class HostListInteractor: HostListInteractorInput {

    typealias CRUDPerformer = any PerformsCRUDOperation<any AddHostFormRepresentable, Host>

    typealias MovePerformer = any PerformsMoveOperation<Host>

    // MARK: - Properties

    weak var presenter: HostListInteractorOutput?
    private let coreDataService: CoreDataServiceProtocol
    private let wakeOnLanService: WakeOnLanService
    private let cacheTracker: TracksHostListCache
    private let hostCrudWorker: CRUDPerformer
    private let hostMoveWorker: MovePerformer

    // MARK: - Init

    init(
        coreDataService: CoreDataServiceProtocol,
        wakeOnLanService: WakeOnLanService,
        cacheTracker: TracksHostListCache,
        hostCrudWorker: CRUDPerformer,
        hostMoveWorker: MovePerformer
    ) {
        self.coreDataService = coreDataService
        self.wakeOnLanService = wakeOnLanService
        self.cacheTracker = cacheTracker
        self.hostCrudWorker = hostCrudWorker
        self.hostMoveWorker = hostMoveWorker
    }

    // MARK: - HostListInteractorInput

    func startCacheTracker() {
        cacheTracker.start()
    }

    func wakeHost(_ host: Host, at indexPath: IndexPath) {
        // NOTE: `@MainActor` is required, not cosmetic. `sendMagicPacket` reads `destination`,
        // `port` and `macAddress` off the passed `Host`, which belongs to the main-queue view
        // context — reading it from the cooperative pool is a queue confinement violation.
        Task { @MainActor in
            do {
                try await wakeOnLanService.sendMagicPacket(to: host)
                DDLogDebug("Magic packet was sent")
                presenter?.interactor(self, didWakeHostAt: indexPath)
            } catch {
                DDLogError("Magic packet was not sent due to error: \(error)")
                presenter?.interactor(self, didFailToWakeHostAt: indexPath, error: error)
            }
        }
    }

    func deleteHost(_ host: Host) {
        guard
            let context = host.managedObjectContext
        else {
            DDLogDebug("Nothing to delete")
            return
        }
        hostCrudWorker.delete(object: host, in: context)
    }

    func fetchHost(at indexPath: IndexPath) -> Host {
        cacheTracker.hostAtIndexPath(indexPath)
    }

    func moveRow(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard
            sourceIndexPath != destinationIndexPath,
            var hosts = cacheTracker.fetchedObjects
        else {
            DDLogDebug("Nothing to move")
            return
        }
        hostMoveWorker.move(
            from: sourceIndexPath,
            to: destinationIndexPath,
            among: &hosts,
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
