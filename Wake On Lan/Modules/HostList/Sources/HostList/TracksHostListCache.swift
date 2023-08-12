//
//  CacheTracker.swift
//
//
//  Created by Vladislav Lisianskii on 05.10.2022.
//

import CoreData
import CoreDataService
import UIKit

protocol TracksHostListCache {

    func start()
    func hostAtIndexPath(_ indexPath: IndexPath) -> Host
    func updateSortDescriptors(sortDescriptors: [NSSortDescriptor])
    func sortDescriptors() -> [NSSortDescriptor]?
}

protocol HostListCacheTrackerDelegate: AnyObject {

    typealias ContentSnapshot = NSDiffableDataSourceSnapshot<String, HostListSectionItem>

    func cacheTracker(
        _ tracker: TracksHostListCache,
        didChangeContentSnapshot contentSnapshot: ContentSnapshot
    )

}
