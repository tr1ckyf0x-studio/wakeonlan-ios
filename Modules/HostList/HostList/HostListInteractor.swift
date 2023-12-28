//
//  HostListInteractor.swift
//  Wake on LAN
//
//  Created by Vladislav Lisianskii on 21.05.2020.
//  Copyright © 2020 Vladislav Lisianskii. All rights reserved.
//

import CocoaLumberjack
import CoreDataService
import SharedProtocolsAndModels
import WakeOnLanService

final class HostListInteractor: HostListInteractorInput {

    typealias CRUDPerformer = any PerformsCRUDOperation<AddHostFormRepresentable, Host>

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
