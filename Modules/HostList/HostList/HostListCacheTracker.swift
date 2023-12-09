//
//  HostListCacheTracker.swift
//  Wake on LAN
//
//  Created by Dmitry on 09.08.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CocoaLumberjack
import CoreData
import CoreDataService

protocol TracksHostListCache {
    var fetchedObjects: [Host]? { get }
    var context: NSManagedObjectContext { get }

    func start()
    func hostAtIndexPath(_ indexPath: IndexPath) -> Host
}

protocol HostListCacheTrackerDelegate: AnyObject {
    func cacheTracker(_ tracker: TracksHostListCache, didChangeContentSnapshot contentSnapshot: HostListSnapshot)
}

final class HostListCacheTracker: NSObject, TracksHostListCache, NSFetchedResultsControllerDelegate {
    typealias Delegate = HostListCacheTrackerDelegate
    typealias SnapshotMapper = MapsSnapshotToHostListItem

    // MARK: - Properties

    weak var delegate: Delegate?

    private var controller: NSFetchedResultsController<Host>
    private let mapper: SnapshotMapper

    // MARK: - Init

    init(
        with fetchRequest: NSFetchRequest<Host>,
        context: NSManagedObjectContext,
        mapper: SnapshotMapper
    ) {
        controller = .init(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        self.mapper = mapper
        super.init()
        self.controller.delegate = self
    }

    // MARK: - CacheTracker

    var fetchedObjects: [Host]? {
        controller.fetchedObjects
    }

    var context: NSManagedObjectContext {
        controller.managedObjectContext
    }

    func start() {
        do {
            try controller.performFetch()
        } catch { // TODO: Error - handling
            DDLogError("HostListCacheTracker can not fetch hosts due to error: \(error)")
        }
    }

    func hostAtIndexPath(_ indexPath: IndexPath) -> Host {
        controller.object(at: indexPath)
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChangeContentWith snapshotReference: NSDiffableDataSourceSnapshotReference
    ) {
        let snapshot = mapper.map(snapshotReference: snapshotReference, context: controller.managedObjectContext)
        delegate?.cacheTracker(self, didChangeContentSnapshot: snapshot)
    }
}
