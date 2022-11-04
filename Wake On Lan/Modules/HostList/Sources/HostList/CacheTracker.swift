//
//  CacheTracker.swift
//
//
//  Created by Vladislav Lisianskii on 05.10.2022.
//

import CoreData
import UIKit

protocol CacheTracker<Object> {

    associatedtype Object: NSFetchRequestResult

    func start()
    func objectAtIndexPath(_ indexPath: IndexPath) -> Object
}

protocol CacheTrackerDelegate<SnapshotSectionIdentifier, SnapshotItemIdentifier>: AnyObject {

    associatedtype SnapshotSectionIdentifier: Hashable
    associatedtype SnapshotItemIdentifier: Hashable

    typealias ContentSnapshot = NSDiffableDataSourceSnapshot<SnapshotSectionIdentifier, SnapshotItemIdentifier>

    func cacheTracker(
        _ tracker: any CacheTracker,
        didChangeContentSnapshot contentSnapshot: ContentSnapshot
    )

}
