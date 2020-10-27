//
//  HostListCacheTracker.swift
//  Wake on LAN
//
//  Created by Dmitry on 09.08.2020.
//  Copyright © 2020 Владислав Лисянский. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjackSwift

protocol HostListCacheTrackerProtocol {

    associatedtype Object: NSFetchRequestResult

    var fetchedObjects: [Object]? { get }

    func objectAtIndexPath(_ indexPath: IndexPath) -> Object

    func indexPathForObject(_ object: Object) -> IndexPath?

}

protocol HostListCacheTrackerDelegate: class {

    associatedtype Object: NSFetchRequestResult

    typealias CacheTracker = HostListCacheTracker<Object, Self>

    func cacheTracker(_ tracker: CacheTracker,
                      didChangeContent content: [CacheTracker.Transaction<Object>])

}

// swiftlint:disable line_length
final class HostListCacheTracker <Object, Delegate: HostListCacheTrackerDelegate>: NSObject, HostListCacheTrackerProtocol, NSFetchedResultsControllerDelegate where Delegate.Object == Object {

    typealias Completion = (_ controller: NSFetchedResultsController<Object>) -> Void

    // MARK: - Transaction
    enum Transaction<Object> {
        case insert(IndexPath, Object)
        case update(IndexPath, Object)
        case move(old: IndexPath, new: IndexPath)
        case delete(IndexPath)
    }

    // MARK: - Properties
    private var controller: NSFetchedResultsController<Object>
    private var transactionStorage = [Transaction<Object>]()
    private weak var delegate: Delegate?
    var fetchedObjects: [Object]? {
        controller.fetchedObjects
    }

    // MARK: - Init
    init(with fetchRequest: NSFetchRequest<Object>,
         context: NSManagedObjectContext,
         delegate: Delegate) {
        controller = .init(fetchRequest: fetchRequest,
                           managedObjectContext: context,
                           sectionNameKeyPath: nil,
                           cacheName: nil)
        super.init()
        self.delegate = delegate
        self.controller.delegate = self
        do {
            try controller.performFetch()
        } catch { // TODO: Error - handling
            DDLogError("HostListCacheTracker can not fetch hosts due to error: \(error)")
        }
    }

    func objectAtIndexPath(_ indexPath: IndexPath) -> Object {
        controller.object(at: indexPath)
    }

    func indexPathForObject(_ object: Object) -> IndexPath? {
        controller.indexPath(forObject: object)
    }

    // MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if transactionStorage.isEmpty { return }
        transactionStorage.removeAll()
    }

    @objc func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                          didChange anObject: Any,
                          at indexPath: IndexPath?,
                          for type: NSFetchedResultsChangeType,
                          newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError("Index path should be not nil") }
            let object = objectAtIndexPath(indexPath)
            transactionStorage.append(.insert(indexPath, object))

        case .update:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            let object = objectAtIndexPath(indexPath)
            transactionStorage.append(.update(indexPath, object))

        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { fatalError("Index path should be not nil") }
            transactionStorage.append(.move(old: indexPath, new: newIndexPath))

        case .delete:
            guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
            transactionStorage.append(.delete(indexPath))

        @unknown default:
            fatalError("Unknown transaction type")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.cacheTracker(self, didChangeContent: transactionStorage)
    }

}
