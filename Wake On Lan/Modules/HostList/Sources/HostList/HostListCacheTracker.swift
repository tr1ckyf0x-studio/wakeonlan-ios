//
//  HostListCacheTracker.swift
//  Wake on LAN
//
//  Created by Dmitry on 09.08.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CocoaLumberjackSwift
import CoreData
import UIKit

final class HostListCacheTracker<
    Object: NSFetchRequestResult,
    SnapshotSectionIdentifier: Hashable,
    SnapshotItemIdentifier: Hashable
>: NSObject,
   CacheTracker,
   NSFetchedResultsControllerDelegate {

    // MARK: - Properties

    typealias Delegate = any CacheTrackerDelegate<SnapshotSectionIdentifier, SnapshotItemIdentifier>
    typealias SnapshotMapper = any MapsSnapshot<SnapshotSectionIdentifier, SnapshotItemIdentifier>

    private var controller: NSFetchedResultsController<Object>
    private let mapper: SnapshotMapper
    weak var delegate: Delegate?

    // MARK: - Init

    init(
        with fetchRequest: NSFetchRequest<Object>,
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

    func start() {
        do {
            try controller.performFetch()
        } catch { // TODO: Error - handling
            DDLogError("HostListCacheTracker can not fetch hosts due to error: \(error)")
        }
    }

    func objectAtIndexPath(_ indexPath: IndexPath) -> Object {
        controller.object(at: indexPath)
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChangeContentWith snapshotReference: NSDiffableDataSourceSnapshotReference
    ) {
        let snapshot = mapper.map(
            snapshotReference: snapshotReference,
            context: controller.managedObjectContext
        )
        delegate?.cacheTracker(self, didChangeContentSnapshot: snapshot)
    }

}
