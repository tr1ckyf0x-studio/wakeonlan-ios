//
//  HostListCacheTracker.swift
//  Wake on LAN
//
//  Created by Dmitry on 09.08.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import CocoaLumberjackSwift
import CoreData
import CoreDataService
import UIKit

final class HostListCacheTracker:
    NSObject,
    TracksHostListCache,
    NSFetchedResultsControllerDelegate {

    // MARK: - Properties

    typealias Delegate = HostListCacheTrackerDelegate
    typealias SnapshotMapper = MapsSnapshotToHostListItem

    private var controller: NSFetchedResultsController<Host>
    private let mapper: SnapshotMapper
    weak var delegate: Delegate?

    private let availibleSortDescriptors = [
        Host.defaultSortDescriptors,
        Host.alphabeticAscendingSortDescriptors,
        Host.alphabeticDescendingSortDescriptors,
        Host.itemIconNameSortDescriptors
    ]

    private var selectedSortDescriptorsIndex = 0

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

    func updateSortDescriptors(sortDescriptors: [NSSortDescriptor]) {
        controller.fetchRequest.sortDescriptors = sortDescriptors
    }

    func sortDescriptors() -> [NSSortDescriptor]? {
        controller.fetchRequest.sortDescriptors
    }

    func nextSortDescriptor() {
        guard !availibleSortDescriptors.isEmpty else {
            DDLogError("No sort descriptors found")
            return
        }

        if selectedSortDescriptorsIndex == availibleSortDescriptors.count - 1 {
            selectedSortDescriptorsIndex = -1
        }

        selectedSortDescriptorsIndex += 1
        updateSortDescriptors(sortDescriptors: availibleSortDescriptors[selectedSortDescriptorsIndex])

        do {
            try controller.performFetch()
        } catch { // TODO: Error - handling
            DDLogError("HostListCacheTracker can not fetch hosts due to error: \(error)")
        }
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
